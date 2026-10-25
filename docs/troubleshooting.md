# Troubleshooting

## Install problems

### Agent not listed in `/agents`

1. Check the location: `~/.claude/agents/` (all projects) or `.claude/agents/` (one project, in the directory where you start `claude`).
2. Check the file ends in `.md` and starts with a `---` frontmatter block.
3. Restart the session. Agent files are read at start.
4. Run `bash scripts/validate-agents.sh` to find frontmatter errors.

### `@name` is not recognised

- `name:` in the frontmatter must be a lowercase slug equal to the filename stem (`python-expert` in `python-expert.agent.md`).
- Two agents with the same `name` conflict; project scope wins over user scope.

### Plugin install does not show the agents

- Start with `claude --plugin-dir /path/to/this/repo` and check `/agents`. The marketplace route (`/plugin marketplace add <owner>/<repo>`, then `/plugin install agent-library@<marketplace>`) needs a `.claude-plugin/marketplace.json`, which this repo does not have yet.
- Confirm the plugin is enabled in the session's plugin list, then restart.
- Fall back to copying files into `~/.claude/agents/`.

## Run problems

### Agent does not finish or loops

1. Narrow the prompt: one outcome, one area of the code.
2. Check `maxTurns`-style limits if you set any in the frontmatter.
3. For orchestration, split into phases and review between them.

### Output is cut short

- Ask for the output in parts ("first the API, then the tests").
- Ask the agent to write to a file instead of printing: "write the result to docs/plan.md".

### Rate limits or usage limits

- Use `model: sonnet` or `haiku` for bulk agents.
- Avoid running many `opus` agents in parallel.
- Wait and retry; limits reset on a schedule.

### Model not available

Edit the agent's `model:` line to `opus`, `sonnet`, `haiku`, `fable` or `inherit`. `inherit` uses whatever the calling session uses.

### Tool denied or permission prompt

- The agent can only use tools listed in `tools:`. Add the one it needs (and no more).
- Edits and shell commands still follow your permission mode.

## Quality problems

### The agent lacks context

Sub-agents start with a clean context. Give file paths, the failing command and the constraint in the prompt:

```
@debug-detective Test test_invoice_total fails with KeyError 'tax'. Code is in billing/invoice.py. Started after commit a1b2c3.
```

### It ignores a requirement

Put hard requirements in a numbered list in the prompt. Put permanent ones in the agent's `<rules>` block.

### Outdated patterns

Name the version ("Python 3.12", "React 19"). Agents with `WebFetch`/`WebSearch` can check current docs.

## Headless problems

### No output or empty file

```bash
claude --agent code-reviewer "Review the diff against origin/main" > review.md
```

- Confirm the CLI is signed in (`claude --version`, then a plain `claude` once).
- In CI, provide the API key through the platform's secret store as an environment variable.

### The agent asks a question and stops

Headless runs cannot answer. State the decisions in the prompt ("use PostgreSQL, no ORM").

## Multi-agent problems

### Inconsistent code between agents

Give the orchestrator the shared contract first (API shapes, naming), then let specialists implement against it.

### Orchestrator does everything itself

Check it is installed with `Agent` in `tools`, and that the specialists exist in `/agents`. It can only spawn installed agents.

### Too many round trips

Ask for the whole outcome in one prompt and list the constraints up front.

## n8n and MCP agents

### `n8n-expert` cannot reach n8n

- Confirm the `n8n` MCP server is configured and connected (`/mcp`).
- The token must come from an environment variable (such as `N8N_API_TOKEN`); never paste it into a prompt or file.
- With the server down the agent writes importable workflow JSON instead.

## Reporting a bug

Use the bug report template. Include the agent name, exact prompt, invocation style, `claude --version`, and the model.
