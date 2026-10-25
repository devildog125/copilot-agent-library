# Launch Copy

Short, accurate text for announcing the library. Claims here are limited to what the repository does today.

## Release notes (v1.0.0)

**Claude Code Agent Library v1.0.0**

37 sub-agents for Claude Code, one Markdown file each.

| Category | Agents |
|---|---|
| Orchestration | 3 |
| Full-Stack | 6 |
| Language and Data Experts | 7 (includes postgres-expert) |
| Testing and Quality | 5 |
| Design and UI/UX | 4 |
| Productivity | 4 |
| DevOps | 4 |
| Automation | 1 (n8n-expert) |
| Debugging | 3 |

What you get:

- Each agent has a model and tool list chosen for its job (opus for judgment work, sonnet for bulk output).
- Review and audit agents are read-only.
- Every agent reports back with a short, structured summary.
- A validator (`scripts/validate-agents.sh`) checks all files.

Install (pick one):

```bash
cp agents/*/*.agent.md ~/.claude/agents/        # all projects
cp agents/*/*.agent.md .claude/agents/          # one project
claude --plugin-dir /path/to/this/repo          # plugin, local checkout
```

Use:

```
@python-expert add type hints to utils.py
```

```bash
claude --agent code-reviewer "Review the diff against main"
```

Docs: [Getting Started](getting-started.md), [Invocation](invocation.md), [Agent Guide](agent-guide.md).

MIT licensed.

## Short post (social)

> Released a library of 37 Claude Code sub-agents: language experts (including a Postgres specialist), read-only reviewers and auditors, an orchestrator, DevOps, design, and an n8n builder. One file each; copy to `~/.claude/agents/` or install as a plugin. MIT.

## Longer post (blog, forum)

Title: "A library of 37 Claude Code sub-agents"

1. **What it is.** Markdown files with a small YAML header. Claude delegates to them or you call them with `@name`.
2. **Why sub-agents.** Each runs in its own context window, so a big code review does not fill your main session, and each can have a narrower tool list.
3. **Design choices.** Model per job, read-only reviewers, a Report back section so the caller gets a summary instead of file dumps, and no secrets in prompts or files.
4. **Try it.** Install `code-reviewer` in `.claude/agents/`, then run `@code-reviewer review my last commit`.
5. **Headless use.** `claude --agent name "task"` in scripts and CI.
6. **Contribute.** See CONTRIBUTING.md.

## Demo ideas

- Orchestrator building a small feature, shown in the session
- `postgres-expert` reading an `EXPLAIN` plan and proposing an index
- `claude --agent code-reviewer` in a CI job

## Notes

- Do not state timing, usage or quality numbers unless you measured them.
- Do not use screenshots that include tokens or personal data.
