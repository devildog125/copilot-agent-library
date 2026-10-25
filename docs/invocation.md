# Invocation: In a Session vs Headless

There are two ways to run an agent. Both use the same agent files.

| | In a session | Headless |
|---|---|---|
| Syntax | `@python-expert refactor utils.py` | `claude --agent python-expert "Refactor utils.py"` |
| Agent runs as | A sub-agent of your session | The main thread |
| You can reply | Yes | No, one prompt, one result |
| Best for | Interactive work, mixed tasks | Scripts, CI, scheduled jobs |
| Result | Summary returned to your session | Printed to stdout |

## In a session

```
@code-reviewer review the changes on this branch
```

- The agent runs in its own context window, so its file reads do not fill yours.
- It returns one summary. Ask the main session for follow-ups.
- Claude can also delegate on its own when your request matches an agent's `description`.
- Run `/agents` to list, create or edit agents.

## Headless

```bash
claude --agent security-auditor "Audit src/auth for injection and session bugs" > audit.md
```

- The agent's system prompt, model and tools apply to the whole run.
- Output goes to stdout, so redirect or pipe it.
- Agents with `Agent` in `tools` (orchestrator, workflow-manager) can still spawn sub-agents.

### In CI

```yaml
- name: Agent review
  run: claude --agent code-reviewer "Review the diff against origin/main" > review.md
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

Rules for CI:

1. Keep the key in the platform's secret store, never in the YAML.
2. Prefer read-only agents (`code-reviewer`, `security-auditor`) in CI.
3. Put the task in the prompt; there is no one to answer questions.

## Which one?

- Exploring, iterating or needing to answer questions: use `@name`.
- Repeatable, unattended or piped output: use `claude --agent name`.
- Several specialists on one job: run `orchestrator` either way.

## Install scope

| Location | Scope |
|---|---|
| `~/.claude/agents/` | All your projects |
| `.claude/agents/` | One project, shareable through git |
| Plugin `agent-library` | Whole library, updated with the plugin |

Project agents override user agents of the same name.
