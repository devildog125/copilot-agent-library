# Getting Started

Install a few agents and run your first task.

## What is a sub-agent?

A Claude Code sub-agent is a Markdown file with YAML frontmatter and a system prompt. Claude delegates to it when the task matches its `description`, or you call it by name. It works in its own context window and returns one summary to the caller.

## Prerequisites

- [Claude Code](https://code.claude.com) installed and signed in (`claude --version` works)
- This repository cloned locally

## Install

Pick one route.

### 1. All projects (user scope)

```bash
mkdir -p ~/.claude/agents
cp agents/*/*.agent.md ~/.claude/agents/
```

### 2. One project

```bash
mkdir -p .claude/agents
cp agents/coding/python-expert.agent.md .claude/agents/
```

Commit `.claude/agents/` and your team gets the same agents.

### 3. Plugin

The repo ships a plugin manifest (`.claude-plugin/plugin.json`, plugin name `agent-library`):

```bash
claude --plugin-dir /path/to/this/repo
```

The marketplace route (`/plugin marketplace add <owner>/<repo>`, then `/plugin install agent-library@<marketplace>`) needs a `.claude-plugin/marketplace.json`, which this repo does not have yet.

### Verify

Start `claude` and run:

```
/agents
```

You should see the installed agents. Claude Code reads agent files at session start, so restart the session after copying new files.

## Your first agent

1. Install `python-expert` (route 2 above).
2. In a session, ask for something it owns:

   ```
   @python-expert write a function that parses a CSV file, with type hints and error handling
   ```

3. Or run it headless:

   ```bash
   claude --agent python-expert "Write a function that parses a CSV file, with type hints and error handling"
   ```

4. Read the summary it returns: what changed, files touched, what was verified, and a suggested next step.

## Frontmatter

Each agent starts with this block:

```yaml
---
name: python-expert
description: Use for Python implementation, refactors, typing, packaging and pytest work.
model: opus
tools: Read, Glob, Grep, Edit, Write, Bash, Agent
---
```

- **name**: lowercase slug, equal to the filename stem. This is what `@name` and `--agent name` resolve.
- **description**: starts with "Use when ...". Claude reads it to decide when to delegate.
- **model**: `opus`, `sonnet`, `haiku`, `fable` or `inherit` (use the caller's model).
- **tools**: comma-separated Claude tool names: `Read, Glob, Grep, Edit, Write, Bash, WebFetch, WebSearch, TodoWrite, Agent`, or `mcp__<server>`. Read-only agents omit `Edit` and `Write`. Listing `Agent` lets the agent spawn other agents.
- **Optional**: `effort` (`low` to `max`), `mcpServers`, `memory`.

## Install several agents

```bash
cp agents/fullstack/{frontend,backend}-developer.agent.md ~/.claude/agents/
cp agents/testing/{test-generator,code-reviewer}.agent.md ~/.claude/agents/
cp agents/orchestration/orchestrator.agent.md ~/.claude/agents/
```

The orchestrator can only delegate to agents that are installed.

## Tips

1. **Be specific.** Name the file, the behaviour and the constraint.
2. **Pick the narrowest agent.** `postgres-expert` for a Postgres query, `sql-expert` for vendor-neutral SQL.
3. **Iterate.** Reply in the session; the agent keeps its context until it finishes.
4. **Use the orchestrator for 3+ specialists.** For one specialist, call it directly.

## Troubleshooting

- **Agent not listed in `/agents`**: wrong directory, filename not ending in `.md`, or session started before the copy. Restart the session.
- **`@name` does nothing**: `name:` must equal the filename stem and be a lowercase slug.
- **More:** [Troubleshooting](troubleshooting.md).

## Next steps

- [Invocation](invocation.md): `@name` vs `claude --agent`
- [Agent Guide](agent-guide.md): all 37 agents
- [Orchestration Patterns](orchestration-patterns.md)
