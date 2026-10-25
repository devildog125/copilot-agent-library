# Best Practices for Claude Code Sub-agents

Habits that get better results from the agents in this library. Examples use `@name` (inside a session) or `claude --agent name` (headless).

## General principles

### 1. Right agent for the job

- One domain: use that specialist (`python-expert`, `postgres-expert`, `docker-expert`).
- Several domains or a set order: use `orchestrator`.
- Review only: use a read-only agent (`code-reviewer`, `security-auditor`).

### 2. Be specific

```
# Bad
@backend-developer make an API

# Good
@backend-developer Add GET/POST /api/projects in src/api with zod validation and JWT auth, following the existing router style
```

### 3. Provide context

Sub-agents start with a clean context. Include file paths, versions, the failing command, and constraints.

### 4. Iterate

Refine in the same session instead of restarting:

```
@frontend-developer Build the login form.
@frontend-developer Add inline validation and an error summary.
@test-generator Cover the form.
```

## Agent-specific tips

- **orchestrator**: describe the outcome, not the steps. "Add password reset with tests and a security review" beats listing which agent does what.
- **code-reviewer**: give a focus ("concurrency in the worker pool"). An unfocused review is shallow. It is read-only.
- **security-auditor**: point it at the trust boundary (auth, uploads, queries). Ask for fixes ranked by severity.
- **test-generator**: name the framework and the edge cases you care about; run the tests it writes.
- **figma-to-html**: supply screenshots or exports. It has no Figma access unless you configured a Figma MCP server.
- **postgres-expert**: give the query, the table sizes, and the connection by environment variable name (`DATABASE_URL`), never the value.
- **n8n-expert**: ask for "validate and test, do not publish" until you have reviewed the workflow.

## Workflow patterns

### TDD

```
@test-generator Write failing tests for the invoice rounding rules.
@python-expert Make the tests pass.
@code-reviewer Review the change.
```

### Design to code

```
@design-system Define tokens from the brand guide.
@figma-to-html Convert designs/home.png using those tokens.
@responsive-design Make it work from 320px up.
```

### Legacy refactor

```
@legacy-modernizer Assess the module and propose an incremental plan.
@test-generator Add characterization tests first.
@legacy-modernizer Execute step 1.
```

### API first

```
@api-designer Produce the OpenAPI spec.
@backend-developer Implement it.
@test-generator Add contract tests.
```

## Performance work

1. Measure first: `@performance-optimizer Profile the dashboard load.`
2. Fix the biggest cost: `@postgres-expert Fix the two slowest queries it found.`
3. Re-measure and compare.

Change one thing at a time so you know what helped.

## Teams

- Run `claude --agent code-reviewer "Review the diff against origin/main"` before opening a PR; humans still review.
- Commit `.claude/agents/` so everyone has the same agents.
- For onboarding: `@doc-generator Write an architecture overview for a new developer`.

## Anti-patterns

1. **Orchestrator for a simple task.** Use the specific agent.
2. **Ignoring limits.** Read-only agents do not edit; agents only have the tools in their `tools:` line.
3. **No human review.** Read the diff and run the tests before committing.
4. **Vague requests.** Name files, behaviour and constraints.
5. **No examples.** Show the style you want ("match src/api/users.ts").
6. **Secrets in prompts.** Use environment variable names.

## Advanced

- **Chaining**: pass each agent's summary into the next prompt, plus the shared contract.
- **Validation pipeline**: implementation, then `code-reviewer`, then `security-auditor`, then `test-generator`.
- **Spec-driven**: keep the spec as the source of truth; change it first, then regenerate.
- **Headless automation**: `claude --agent <name> "..."` in scripts and CI; see [Invocation](invocation.md).

## Measuring success

- Fewer review round trips
- Tests pass on the first run
- Less time on boilerplate

Measure your own numbers; do not assume them.

## Next steps

- [Agent Guide](agent-guide.md)
- [Orchestration Patterns](orchestration-patterns.md)
- [Troubleshooting](troubleshooting.md)
