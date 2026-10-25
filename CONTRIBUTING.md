# Contributing

Thanks for helping. This guide covers adding or improving a Claude Code sub-agent.

## Ways to contribute

- New agents
- Improvements to existing agents
- Documentation and examples
- Bug fixes (use the bug report issue template)

## Getting started

1. Fork and clone the repository.
2. Create a branch: `git checkout -b feature/agent-name`.
3. Make your change and test it (below).
4. Run `bash scripts/validate-agents.sh`.
5. Open a pull request.

## Quality standards

### Frontmatter

```yaml
---
name: my-agent
description: Use when you need X. It does Y.
model: sonnet
tools: Read, Glob, Grep
---
```

- `name`: lowercase slug, equal to the filename stem (`my-agent.agent.md`). This is what `@my-agent` and `claude --agent my-agent` resolve.
- `description`: starts with "Use when ..." so Claude knows when to delegate.
- `model`: `opus` for judgment-heavy work (implementation, design, review, debugging), `sonnet` for bulk or pattern-following output, `haiku` for trivial lookups, `fable` where you want it, `inherit` for coordinators that run as the main thread.
- `tools`: comma-separated Claude tool names: `Read, Glob, Grep, Edit, Write, Bash, WebFetch, WebSearch, TodoWrite, Agent`, or `mcp__<server>`. Give the minimum. Read-only agents omit `Edit` and `Write`.
- Optional: `effort` (`low`, `medium`, `high`, `xhigh`, `max`; only where the default is wrong), `mcpServers`, `memory`.
- Do not use `agents:` or `handoffs:`. To delegate, put `Agent` in `tools` and describe it in a Delegation section.

### Body sections, in order

1. Intro: who the agent is
2. **Core Capabilities**
3. **Workflow**: inspect, act, verify
4. `<rules>`
5. **Delegation** (only if `Agent` is in `tools`): which sub-agents, and when
6. **Report back**: what to return (what changed, files touched, what was verified, one next step; never whole files)
7. **Usage**: one `@name` and one `claude --agent name` example

### Content rules

- No secrets, tokens or personal data. Refer to environment variable names, never values.
- No claims the agent cannot back up with its tools (for example, Figma access without a Figma tool).
- Distinct from existing agents.

## Creating an agent

1. Pick a category directory: `orchestration`, `fullstack`, `coding`, `testing`, `design`, `productivity`, `devops`, `automation`, `debugging`.
2. Copy the template:

   ```bash
   cp templates/agent-template.md agents/<category>/<agent-name>.agent.md
   ```

3. Fill it in, then add a row to the README table and a section in `docs/agent-guide.md` and `TESTING.md`.

## Testing your agent

```bash
bash scripts/validate-agents.sh

mkdir -p .claude/agents
cp agents/<category>/<agent-name>.agent.md .claude/agents/
claude
```

In the session:

1. `/agents` lists it.
2. `@<agent-name> <test prompt>` works.
3. Headless works: `claude --agent <agent-name> "<test prompt>"`.
4. Tools are enough, and no more than needed (a read-only agent changes nothing).
5. If it has `Agent` in `tools`, the named sub-agents are actually spawned.

## Pull request checklist

```markdown
## Agent: [name]

**Category**: [category]
**Model / tools**: [model; tools]

- [ ] `bash scripts/validate-agents.sh` passes
- [ ] Tested with `@name` in a session
- [ ] Tested with `claude --agent name`
- [ ] README, docs/agent-guide.md and TESTING.md updated
- [ ] No secrets or personal data

**Notes**: [anything special]
```

## Review

Reviewers check quality, completeness, evidence of testing, clear docs, no overlap with existing agents, and real value. Expect a first response in 3 to 5 business days.

## Multi-agent patterns

- **Sequential**: agent A finishes, the caller passes its summary to agent B.
- **Parallel**: a coordinator spawns independent agents at once.
- **Hierarchical**: orchestrator, specialists, and their helpers (sub-agents can spawn sub-agents when `Agent` is in `tools`).

See [Orchestration Patterns](docs/orchestration-patterns.md).

## Code of conduct

Be respectful, constructive, inclusive and professional. Harassment, personal attacks and sharing others' private information are not tolerated. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) for how to report.

## Questions

Open a GitHub Discussion or Issue.
