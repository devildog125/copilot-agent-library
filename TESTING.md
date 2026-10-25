# Testing Guide

How to check that each of the 37 agents loads, runs and behaves.

## 1. Static check

```bash
bash scripts/validate-agents.sh
```

Expected: 37 passed, 0 errors. It checks frontmatter (`name` equals filename stem, valid `model`, known `tools`), rejects `agents:`/`handoffs:` keys, and requires a `## Report back` section.

## 2. Setup for live tests

```bash
mkdir -p .claude/agents
cp agents/*/*.agent.md .claude/agents/
claude
```

Then in the session:

```
/agents
```

Pass: all 37 agents are listed. Remove `.claude/agents/` afterwards unless you want it.

## 3. Universal criteria (every agent)

- [ ] Listed in `/agents`
- [ ] `@name <prompt>` runs without an error
- [ ] `claude --agent name "<prompt>"` runs and prints a result
- [ ] Reply ends with a short summary: what changed, files touched, what was verified, one next step
- [ ] Read-only agents (code-reviewer, security-auditor, debug-detective, performance-optimizer, research-agent, ab-test-ideas) change no files (`git status` stays clean)
- [ ] No secrets, tokens or personal data in the output
- [ ] Agents with `Agent` in `tools` name the sub-agents they spawn

## 4. Scenarios

Run each prompt as `@name <prompt>` and again headless. Use a scratch repository.

### Orchestration

| Agent | Prompt | Pass if |
|---|---|---|
| orchestrator | Add password reset: API, UI, tests, security review | Spawns at least backend, frontend, test and security agents; one integrated summary |
| workflow-manager | Plan: run tests, build image, deploy staging, smoke test | Dependencies explicit; independent steps marked parallel; failure handling stated |
| project-manager | Plan a two-week sprint from this backlog | Stories, estimates, capacity check, risks |

### Full-Stack

| Agent | Prompt | Pass if |
|---|---|---|
| frontend-developer | Build an accessible sortable table component | Typed component, keyboard and ARIA support |
| backend-developer | Add CRUD endpoints for `projects` with validation and auth | All routes, validation, error handling |
| fullstack-expert | Add a notifications feed end to end | UI, API and storage changes agree |
| mobile-developer | Add offline caching to the order list | Platform-appropriate storage and sync handling |
| api-designer | Draft an OpenAPI spec for billing | Valid OpenAPI, consistent errors, versioning stated |
| database-architect | Model multi-tenant projects with roles | Keys, constraints, indexes, tenancy isolation |

### Language and Data

| Agent | Prompt | Pass if |
|---|---|---|
| python-expert | Add type hints to utils.py and run mypy and pytest | Runs the tools, reports results; may spawn test-generator |
| javascript-expert | Convert callbacks in queue.js to async/await | Behaviour preserved, tests still pass |
| rust-expert | Remove clones in the parser hot path | Compiles; `cargo clippy` clean |
| go-expert | Fix the goroutine leak in the worker pool | Cancellation via context; `go test -race` passes |
| java-expert | Migrate controller tests to JUnit 5 | Builds and tests pass |
| sql-expert | Rewrite a five-table join to avoid the sort | Same results, plan evidence, indexes suggested |
| postgres-expert | The orders report is slow; find out why | Uses `EXPLAIN (ANALYZE, BUFFERS)`, reports before/after cost, no writes to a live database, connection by env var name only |

### Testing and Quality

| Agent | Prompt | Pass if |
|---|---|---|
| e2e-tester | Write Playwright tests for checkout | Stable selectors, no fixed sleeps |
| ab-test-ideas | Propose three signup experiments | Hypothesis, metric and sample-size note for each |
| code-reviewer | Review this branch | Findings ranked by severity with file and line; no edits |
| security-auditor | Audit src/auth | Findings mapped to OWASP categories with fixes; no edits |
| test-generator | Write pytest tests for invoice.py | Tests run and pass; edge cases covered |

### Design

| Agent | Prompt | Pass if |
|---|---|---|
| uiux-designer | Review the onboarding flow | Specific friction points and fixes |
| figma-to-html | Convert design.png to a React component | Works from the supplied image; does not claim Figma access it lacks |
| responsive-design | Make the pricing page work from 320px | Mobile-first CSS, breakpoints, accessibility notes |
| design-system | Extract tokens from the existing CSS | Token file plus usage notes |

### Productivity

| Agent | Prompt | Pass if |
|---|---|---|
| enhanced-planner | Plan the REST to GraphQL migration | Phases, dependencies, risks |
| research-agent | Compare three Node job-queue libraries | Sources cited; no file changes |
| task-breakdown | Break the reporting epic into stories | Acceptance criteria and estimates |
| doc-generator | Write API docs for src/api | Matches the code; examples run |

### DevOps

| Agent | Prompt | Pass if |
|---|---|---|
| docker-expert | Shrink the production image | Multi-stage build, non-root user, size reported |
| kubernetes-expert | Why is the api pod in CrashLoopBackOff? | Diagnosis steps and a fix; no changes to a live cluster without being told |
| cicd-expert | Add caching and a matrix to the test workflow | Valid YAML; secrets from the platform store |
| terraform-expert | Split the stack into modules | `terraform validate` passes; plan reviewed before apply |

### Automation

| Agent | Prompt | Pass if |
|---|---|---|
| n8n-expert | Build a workflow that posts new GitHub issues to Slack | Calls `get_instance_context` first, validates before testing, does not publish or execute without your go-ahead; with the server stopped, produces importable workflow JSON |

### Debugging

| Agent | Prompt | Pass if |
|---|---|---|
| debug-detective | Find why the nightly job fails on the first of the month | Reproduces or reasons to a root cause; no edits |
| performance-optimizer | Find the bottleneck in dashboard load | Measurements before conclusions; no edits |
| legacy-modernizer | Plan a jQuery to React move | Incremental steps with a rollback path |

## 5. Recording results

For each failure, open a bug report using `.github/ISSUE_TEMPLATE/bug_report.md` with the agent name, the exact prompt, the invocation (`@name` or headless) and the Claude Code version (`claude --version`).
