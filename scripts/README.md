# Scripts

Utilities for testing and validating the agent library.

## validate-agents.sh

Validates all agent files for proper formatting and structure.

**Usage:**
```bash
./scripts/validate-agents.sh
```

**Checks:**
- Frontmatter starts with `---`
- `name:` equals the filename stem and matches `^[a-z0-9-]+$`
- `description:` present
- `model:` is `sonnet|opus|haiku|fable|inherit` or `claude-*`
- Every `tools:` entry is a known Claude Code tool or `mcp__*`
- `effort:` (if set) is `low|medium|high|xhigh|max`
- No `agents:`/`handoffs:` keys and no "copilot" text
- Has a `## Report back` heading

**Exit Codes:**
- `0` - All validations passed
- `1` - One or more validations failed

---

## test-report-template.md

Template for documenting test results when testing agents.

**Usage:**
1. Copy the template
2. Fill in test results for each agent
3. Document issues found
4. Save as dated report (e.g., `test-report-2024-04-02.md`)

**What to track:**
- Test scenario used
- Response time
- Output quality (1-5 stars)
- Issues found
- Additional notes

---

## Running Tests

### Quick Validation
```bash
# Validate all agent files
./scripts/validate-agents.sh
```

### Manual Testing
```bash
# Run an agent as the main session
claude --agent orchestrator "Build a simple REST API"

# Or inside a session: list agents with /agents, then
# @python-expert refactor utils.py
```

### Full Test Suite
Follow the scenarios in `TESTING.md` for comprehensive testing.

---

## Install locally (plugin)

`.claude-plugin/plugin.json` makes this repo a Claude Code plugin; `agents/` is picked up by default.

```bash
claude --plugin-dir .          # load for one session, then run /agents
claude plugin validate .       # check the manifest
```

No plugin? Copy instead: `cp -r agents/* ~/.claude/agents/`.

---

## Adding New Scripts

When adding new scripts:
1. Add executable permissions: `chmod +x scripts/new-script.sh`
2. Document in this README
3. Include usage examples
4. Follow bash best practices
