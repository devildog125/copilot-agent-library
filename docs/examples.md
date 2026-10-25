# Examples

Each example shows the in-session form (`@name`) and the headless form (`claude --agent name`). Outputs are illustrative.

## Quick examples

### Code review

```bash
git fetch origin pull/123/head:pr-123 && git checkout pr-123
claude --agent code-reviewer "Review the diff against main for security, performance and best practices"
```

Typical result: findings ranked by severity with file and line, for example a string-concatenated SQL query (use parameters) and an N+1 query in `getUserPosts()`. The reviewer is read-only, so nothing is edited.

### React component

```
@frontend-developer Create a DataTable component with column sorting, search filtering and 20-row pagination. TypeScript, accessible.
```

### REST API design

```
@api-designer Design a REST API for a task manager: projects, tasks, comments. Output OpenAPI 3.1.
```

## Single-agent workflows

### Backend API

```bash
claude --agent backend-developer "Add CRUD endpoints for projects in src/api with input validation and JWT auth. Follow the existing router style."
```

### Database design and tuning

```
@database-architect Model multi-tenant projects with roles and audit history.
@postgres-expert The orders report takes 12 s. Run EXPLAIN (ANALYZE, BUFFERS) and propose an index.
```

`postgres-expert` reports the before and after plan cost. Give it the connection by environment variable name (`DATABASE_URL`); it never needs the value in the prompt.

### E2E tests

```
@e2e-tester Write Playwright tests for login, add to cart and checkout. Use data-testid selectors.
```

## Multi-agent workflows

### Feature end to end

```bash
claude --agent orchestrator "Add password reset: email token endpoint, reset form, tests, security review"
```

The orchestrator delegates to backend-developer, frontend-developer, test-generator and security-auditor, then returns one summary.

### Security-first

```
@backend-developer Implement the login endpoint.
@security-auditor Audit the login endpoint just added.
@backend-developer Fix the findings.
```

### Design to production

```
@figma-to-html Convert designs/pricing.png to a React component.
@responsive-design Make it work from 320px up.
@test-generator Add component tests.
```

## Before and after

### Slow query

Before: five-table join with `SELECT *` and no indexes.

```
@sql-expert Optimize this query: <paste>
```

After: explicit columns, a composite index on `(customer_id, order_date)`, a CTE for the monthly aggregate, and the plan evidence.

### Missing tests

```bash
claude --agent test-generator "Write pytest tests for billing/invoice.py, including empty cart and rounding"
```

## Real-world scenarios

### Add OAuth

```
@enhanced-planner Plan OAuth login for the existing session-based app.
@backend-developer Implement the OAuth callback and account linking.
@frontend-developer Add the sign-in buttons.
@test-generator Cover the callback paths.
@security-auditor Review the whole flow.
```

### Performance problem

```
@performance-optimizer Find the bottleneck in the dashboard load (measure first).
@postgres-expert Fix the slow queries it found.
@performance-optimizer Re-measure.
```

### Legacy migration

```
@legacy-modernizer Assess the jQuery admin and propose an incremental plan.
@frontend-developer Migrate the first page.
```

## n8n

```
@n8n-expert Build a workflow that posts new GitHub issues to Slack. Validate and test it; do not publish.
```

## Writing good prompts

1. Name the files and the constraint.
2. Say what "done" means (tests pass, plan cost drops).
3. Give versions and style.
4. One outcome per prompt.
