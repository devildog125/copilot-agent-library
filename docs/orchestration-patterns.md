# Orchestration Patterns

How to combine agents. A sub-agent works in its own context and returns one summary; coordination happens through the `Agent` tool.

## Single agent or orchestrator?

Use **one agent** when the task sits in one domain: a review, a query, a Dockerfile.

Use the **orchestrator** when the task spans domains (UI, API, database, tests) or needs several specialists in a set order.

## How delegation works

- An agent can spawn other agents only if `Agent` is in its `tools`.
- Sub-agents can spawn sub-agents, up to three levels deep.
- The caller sees only the sub-agent's final summary, so each agent's **Report back** section matters.
- `orchestrator` and `workflow-manager` use `model: inherit` and are meant to run as the main thread:

```bash
claude --agent orchestrator "Build a task-management REST API with tests"
```

or inside a session: `@orchestrator Build a task-management REST API with tests`.

All specialists must be installed (`/agents` shows them).

## Patterns

### 1. Sequential

Each step needs the previous result.

```
orchestrator
  1. api-designer       -> endpoints and schemas
  2. database-architect -> schema from the design
  3. backend-developer  -> implementation
  4. security-auditor   -> review
  5. test-generator     -> tests
```

### 2. Parallel

Independent work runs at once; the coordinator merges the summaries.

```
orchestrator
  |- frontend-developer  (UI)
  |- backend-developer   (API)
  |- doc-generator       (docs)
```

Only parallelise tasks that touch different files.

### 3. Hub and spoke

One coordinator, specialists never talk to each other. The hub passes the relevant part of one summary into the next prompt. This is the default `orchestrator` shape.

### 4. Iterative refinement

```
backend-developer -> code-reviewer -> backend-developer -> code-reviewer
```

Stop when the reviewer reports no blocking findings. Cap it at three rounds.

### 5. Validation gate

Read-only agents act as gates after the build: `code-reviewer`, `security-auditor`, `performance-optimizer`. They cannot edit, so they cannot hide a problem by "fixing" it.

## Examples

### Checkout flow

```bash
claude --agent orchestrator "Add checkout: cart API, payment form UI, order table, and tests. Payments must go through the existing provider SDK; no card data stored."
```

Expected delegation: api-designer, database-architect, backend-developer, frontend-developer, test-generator, security-auditor.

### Migration

```bash
claude --agent orchestrator "Plan and start migrating the jQuery admin pages to React, one page at a time"
```

Expected delegation: legacy-modernizer (plan), enhanced-planner (phases), frontend-developer (first page), test-generator (parallel tests).

### Greenfield

Run phases separately and review between them:

1. `@enhanced-planner` produce the plan.
2. `@api-designer` and `@database-architect` produce the contracts.
3. `@orchestrator` implement against those contracts.

## Passing context

- Repeat the shared contract (API shapes, naming) in the prompt; sub-agents do not see your session.
- State integration points: "the frontend calls `POST /api/orders` and expects `{id, status}`".
- Ask for file paths in each summary so the next agent can find the work.

## Practical advice

1. Start with clear requirements and constraints.
2. Break large projects into phases and review between them.
3. Give an example of the style you want.
4. If agents disagree, settle the contract first and rerun the later steps.
5. Keep secrets out of prompts; refer to environment variable names.

## Next steps

- [Agent Guide](agent-guide.md)
- [Invocation](invocation.md)
- [Troubleshooting](troubleshooting.md)
