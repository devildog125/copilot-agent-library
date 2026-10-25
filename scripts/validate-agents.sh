#!/bin/bash
# Agent Validation Script
# Checks every agents/**/*.agent.md against the Claude Code sub-agent schema.

set -e   # Abort on unexpected failures; counters below use $((...)) so they never trip this.

AGENTS_DIR="${AGENTS_DIR:-./agents}"   # Overridable so a scratch dir can be tested.
ERRORS=0     # Number of files with at least one error.
WARNINGS=0   # Number of soft problems (size, length).

# Tools a sub-agent may list in `tools:` (mcp__* is also allowed, matched separately).
KNOWN_TOOLS="Read Glob Grep Edit Write Bash WebFetch WebSearch TodoWrite Agent Skill NotebookEdit"

# Colors for output.
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Agent Library - Validation Script"
echo "=============================================="
echo ""

# Bail out early if there is nothing to validate.
if [ ! -d "$AGENTS_DIR" ]; then
  echo -e "${RED}Error: agents/ directory not found${NC}"
  exit 1
fi

# Count total agents (tr strips the padding macOS wc adds).
TOTAL_AGENTS=$(find "$AGENTS_DIR" -name "*.agent.md" | wc -l | tr -d ' ')
echo "Found $TOTAL_AGENTS agent files"
echo ""

# fail NAME MSG: print one error line for an agent and bump the per-file problem flag.
fail() {
  echo -e "${RED}$1: $2${NC}"   # Show which agent and what is wrong.
  PROBLEMS=$((PROBLEMS+1))      # Counted per problem; the file is counted once after its checks.
}

# Validate each agent file (while-read handles paths with spaces, unlike a for loop).
while IFS= read -r agent_file; do
  AGENT_NAME=$(basename "$agent_file" .agent.md)   # Filename stem, which `name:` must equal.
  PROBLEMS=0                                       # Reset per file.

  # Check 1: file is not empty.
  if [ ! -s "$agent_file" ]; then
    fail "$AGENT_NAME" "file is empty"
    ERRORS=$((ERRORS+1))   # Count this file as failed (no counter abort under set -e).
    continue               # Nothing else can be checked on an empty file.
  fi

  # Check 2: frontmatter opens on line 1.
  if [ "$(head -n 1 "$agent_file")" != "---" ]; then
    fail "$AGENT_NAME" "missing YAML frontmatter (must start with ---)"
    ERRORS=$((ERRORS+1))   # Count this file as failed.
    continue               # Without frontmatter the field checks are meaningless.
  fi

  # Frontmatter = lines between the first and second `---` (closing line is excluded).
  FM=$(awk 'NR==1{next} /^---[[:space:]]*$/{exit} {print}' "$agent_file")

  # field KEY: value of a top-level `KEY:` line, quotes and surrounding spaces removed.
  field() {
    printf '%s\n' "$FM" | sed -n "s/^$1:[[:space:]]*//p" | head -n 1 \
      | sed -e 's/[[:space:]]*$//' -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'\$/\1/"
  }

  # Check 3: name equals filename stem and is a slug.
  NAME=$(field name)
  if [ -z "$NAME" ]; then
    fail "$AGENT_NAME" "missing 'name:'"
  else
    [ "$NAME" = "$AGENT_NAME" ] || fail "$AGENT_NAME" "name '$NAME' != filename stem '$AGENT_NAME'"   # @name resolves by name only.
    printf '%s' "$NAME" | grep -Eq '^[a-z0-9-]+$' || fail "$AGENT_NAME" "name '$NAME' must match ^[a-z0-9-]+\$"   # Slug rule.
  fi

  # Check 4: description present (key only; block scalars like `>` have an empty first line).
  printf '%s\n' "$FM" | grep -q '^description:' || fail "$AGENT_NAME" "missing 'description:'"

  # Check 5: model is an alias or a full claude-* id.
  MODEL=$(field model)
  if [ -z "$MODEL" ]; then
    fail "$AGENT_NAME" "missing 'model:'"
  else
    case "$MODEL" in
      sonnet|opus|haiku|fable|inherit|claude-*) ;;   # Allowed values.
      *) fail "$AGENT_NAME" "invalid model '$MODEL'" ;;
    esac
  fi

  # Check 6: every tools entry is known or mcp__*. Accepts "a, b" strings and YAML lists.
  TOOLS=$(printf '%s\n' "$FM" | awk '
    /^tools:/ {                                  # Start of the tools key.
      sub(/^tools:[[:space:]]*/, ""); print      # Inline value (comma string) if any.
      intools=1; next }
    intools && /^[[:space:]]*-[[:space:]]/ {     # YAML list item under tools.
      sub(/^[[:space:]]*-[[:space:]]*/, ""); print; next }
    intools { intools=0 }                        # Any other line ends the list.
  ' | tr ',' '\n' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'\$/\1/" -e '/^$/d')
  while IFS= read -r tool; do
    [ -n "$tool" ] || continue                                       # Skip when tools: is absent.
    case "$tool" in mcp__*) continue ;; esac                         # Any MCP tool is allowed.
    case " $KNOWN_TOOLS " in *" $tool "*) ;; *) fail "$AGENT_NAME" "unknown tool '$tool'" ;; esac   # Typos like `read` are caught here.
  done <<< "$TOOLS"

  # Check 7: effort, if present, is a valid level.
  EFFORT=$(field effort)
  if [ -n "$EFFORT" ]; then
    case "$EFFORT" in
      low|medium|high|xhigh|max) ;;   # Allowed values.
      *) fail "$AGENT_NAME" "invalid effort '$EFFORT'" ;;
    esac
  fi

  # Check 8: Copilot-only frontmatter keys must be gone.
  printf '%s\n' "$FM" | grep -Eq '^(agents|handoffs):' && fail "$AGENT_NAME" "'agents:'/'handoffs:' are Copilot-only; remove"

  # Check 9: no leftover Copilot references anywhere in the file.
  grep -qi 'copilot' "$agent_file" && fail "$AGENT_NAME" "contains 'copilot'"

  # Check 10: hand-back contract heading is present.
  grep -q '^## Report back' "$agent_file" || fail "$AGENT_NAME" "missing '## Report back' heading"

  # Soft check: very short body (lines after the frontmatter block).
  CONTENT_LINES=$(tail -n +10 "$agent_file" | grep -vc '^$' || true)   # `|| true`: grep -c exits 1 on zero matches.
  if [ "$CONTENT_LINES" -lt 10 ]; then
    echo -e "${YELLOW}$AGENT_NAME: very short content (< 10 lines)${NC}"
    WARNINGS=$((WARNINGS+1))
  fi

  # Soft check: small file. stat -c is GNU/Linux, stat -f is macOS/BSD.
  FILE_SIZE=$(stat -c%s "$agent_file" 2>/dev/null || stat -f%z "$agent_file" 2>/dev/null)
  if [ "$FILE_SIZE" -lt 1000 ]; then
    echo -e "${YELLOW}$AGENT_NAME: small file size (< 1KB)${NC}"
    WARNINGS=$((WARNINGS+1))
  fi

  # Tally: one failed file counts once, regardless of how many problems it had.
  if [ "$PROBLEMS" -gt 0 ]; then
    ERRORS=$((ERRORS+1))
  else
    echo -e "${GREEN}OK $AGENT_NAME${NC}"
  fi
done < <(find "$AGENTS_DIR" -name "*.agent.md" | sort)

echo ""
echo "=============================================="
echo "Validation Summary"
echo "=============================================="
echo "Total agents: $TOTAL_AGENTS"
echo -e "${GREEN}Passed: $((TOTAL_AGENTS - ERRORS))${NC}"
echo -e "${RED}Errors: $ERRORS${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo ""

# Non-zero exit makes CI fail on any error.
if [ "$ERRORS" -gt 0 ]; then
  echo -e "${RED}Validation failed: $ERRORS agent file(s) with errors${NC}"
  exit 1
fi

echo -e "${GREEN}All validations passed!${NC}"
[ "$WARNINGS" -gt 0 ] && echo -e "${YELLOW}$WARNINGS warning(s) - review recommended${NC}"   # Only prints when there are warnings.

echo ""
echo "Next steps:"
echo "1. List the agents in Claude Code: run /agents"
echo "2. Run one directly: claude --agent <name>"
echo "3. Run test scenarios from TESTING.md"
exit 0   # Explicit: the `[ ] &&` line above can leave a non-zero status under set -e.
