# Agent Guide

Reference for all 37 agents. Model and tools are in each agent's frontmatter; `/agents` shows them in a session.

Every agent returns a short summary to its caller: what changed, files touched, what was verified, and one recommended next step.

## Contents

- [Orchestration](#orchestration) (3)
- [Full-Stack Development](#full-stack-development) (6)
- [Language and Data Experts](#language-and-data-experts) (7)
- [Testing and Quality](#testing-and-quality) (5)
- [Design and UI/UX](#design-and-uiux) (4)
- [Productivity](#productivity) (4)
- [DevOps](#devops) (4)
- [Automation](#automation) (1)
- [Debugging](#debugging) (3)

## Orchestration

### Orchestrator

**Best for:** Large tasks that need several specialists  
**Model:** inherit  
**Run:** `@orchestrator Add password reset: API endpoint, UI form, tests and a security review` or `claude --agent orchestrator "Add password reset: API endpoint, UI form, tests and a security review"`

### Workflow Manager

**Best for:** Ordering and parallelising multi-step jobs  
**Model:** inherit  
**Run:** `@workflow-manager Plan a release: tests, Docker build, staging deploy, smoke tests` or `claude --agent workflow-manager "Plan a release: tests, Docker build, staging deploy, smoke tests"`

### Project Manager

**Best for:** Sprint plans, status reports, risk lists  
**Model:** sonnet (effort: medium)  
**Run:** `@project-manager Plan a two-week sprint from the backlog in BACKLOG.md` or `claude --agent project-manager "Plan a two-week sprint from the backlog in BACKLOG.md"`

## Full-Stack Development

### Frontend Developer

**Best for:** React/Vue/Angular components and state  
**Model:** opus  
**Run:** `@frontend-developer Build an accessible data table with sorting and pagination` or `claude --agent frontend-developer "Build an accessible data table with sorting and pagination"`

### Backend Developer

**Best for:** APIs, auth, persistence  
**Model:** opus  
**Run:** `@backend-developer Add refresh-token rotation to the auth service` or `claude --agent backend-developer "Add refresh-token rotation to the auth service"`

### Full-Stack Expert

**Best for:** One feature across UI, API and database  
**Model:** opus  
**Run:** `@fullstack-expert Add a notifications feed end to end` or `claude --agent fullstack-expert "Add a notifications feed end to end"`

### Mobile Developer

**Best for:** React Native, Flutter, native iOS/Android  
**Model:** opus  
**Run:** `@mobile-developer Add offline caching to the order list screen` or `claude --agent mobile-developer "Add offline caching to the order list screen"`

### API Designer

**Best for:** REST contracts, OpenAPI, versioning  
**Model:** opus  
**Run:** `@api-designer Draft an OpenAPI spec for the billing service` or `claude --agent api-designer "Draft an OpenAPI spec for the billing service"`

### Database Architect

**Best for:** Schema design and data modelling  
**Model:** opus (effort: xhigh, memory: project)  
**Run:** `@database-architect Model multi-tenant projects with roles and audit history` or `claude --agent database-architect "Model multi-tenant projects with roles and audit history"`

## Language and Data Experts

### Python Expert

**Best for:** Python 3.12+ code, typing, packaging, pytest; delegates test writing to `test-generator`  
**Model:** opus  
**Run:** `@python-expert Add type hints to utils.py and fix the mypy errors` or `claude --agent python-expert "Add type hints to utils.py and fix the mypy errors"`

### JavaScript Expert

**Best for:** Modern JS/TypeScript and Node.js  
**Model:** opus  
**Run:** `@javascript-expert Convert callbacks in lib/queue.js to async/await` or `claude --agent javascript-expert "Convert callbacks in lib/queue.js to async/await"`

### Rust Expert

**Best for:** Ownership, lifetimes, async Rust  
**Model:** opus  
**Run:** `@rust-expert Remove the clones in the parser hot path` or `claude --agent rust-expert "Remove the clones in the parser hot path"`

### Go Expert

**Best for:** Concurrency and idiomatic Go  
**Model:** opus  
**Run:** `@go-expert Fix the goroutine leak in the worker pool` or `claude --agent go-expert "Fix the goroutine leak in the worker pool"`

### Java Expert

**Best for:** Spring Boot, Maven/Gradle, JUnit  
**Model:** opus  
**Run:** `@java-expert Migrate the controller tests to JUnit 5` or `claude --agent java-expert "Migrate the controller tests to JUnit 5"`

### SQL Expert

**Best for:** Vendor-neutral SQL, tuning, migrations  
**Model:** opus  
**Run:** `@sql-expert Rewrite this five-table join to avoid the sort` or `claude --agent sql-expert "Rewrite this five-table join to avoid the sort"`

### Postgres Expert

**Best for:** PostgreSQL only: `EXPLAIN (ANALYZE, BUFFERS)`, btree/GIN/GiST/BRIN, partial and covering indexes, partitioning, VACUUM/autovacuum, locks, `pg_stat_statements`, extensions, migrations, pooling, RLS. Read-only against a live database unless told otherwise; connection details by environment variable name (such as `DATABASE_URL`), never by value. Reports before/after plan cost  
**Model:** opus (effort: xhigh)  
**Run:** `@postgres-expert The orders report is slow. Find out why and propose an index` or `claude --agent postgres-expert "The orders report is slow. Find out why and propose an index"`

## Testing and Quality

### E2E Tester

**Best for:** Playwright, Cypress, Selenium suites  
**Model:** sonnet  
**Run:** `@e2e-tester Write Playwright tests for checkout` or `claude --agent e2e-tester "Write Playwright tests for checkout"`

### A/B Test Ideas

**Best for:** Experiment design and hypotheses  
**Model:** sonnet (read-only)  
**Run:** `@ab-test-ideas Propose three experiments to lift signup conversion` or `claude --agent ab-test-ideas "Propose three experiments to lift signup conversion"`

### Code Reviewer

**Best for:** Reviewing a diff for bugs and design problems  
**Model:** opus (read-only, memory: project)  
**Run:** `@code-reviewer Review the changes on this branch` or `claude --agent code-reviewer "Review the changes on this branch"`

### Security Auditor

**Best for:** OWASP-style vulnerability review  
**Model:** opus (effort: xhigh, read-only)  
**Run:** `@security-auditor Audit src/auth for injection and session bugs` or `claude --agent security-auditor "Audit src/auth for injection and session bugs"`

### Test Generator

**Best for:** Unit and integration tests for existing code  
**Model:** sonnet  
**Run:** `@test-generator Write pytest tests for billing/invoice.py` or `claude --agent test-generator "Write pytest tests for billing/invoice.py"`

## Design and UI/UX

### UI/UX Designer

**Best for:** Flows, wireframes, usability review  
**Model:** opus  
**Run:** `@uiux-designer Review the onboarding flow and list the top five friction points` or `claude --agent uiux-designer "Review the onboarding flow and list the top five friction points"`

### Figma to HTML

**Best for:** Screenshots or exports to HTML/CSS/React. Uses a Figma MCP server only if you have configured one  
**Model:** sonnet  
**Run:** `@figma-to-html Convert design.png to a React component with TypeScript` or `claude --agent figma-to-html "Convert design.png to a React component with TypeScript"`

### Responsive Design

**Best for:** Mobile-first layouts and accessibility  
**Model:** opus  
**Run:** `@responsive-design Make the pricing page work from 320px up` or `claude --agent responsive-design "Make the pricing page work from 320px up"`

### Design System Builder

**Best for:** Tokens and component libraries  
**Model:** opus  
**Run:** `@design-system Extract colour and spacing tokens from the existing CSS` or `claude --agent design-system "Extract colour and spacing tokens from the existing CSS"`

## Productivity

### Enhanced Planner

**Best for:** Plans with dependencies and risks  
**Model:** opus  
**Run:** `@enhanced-planner Plan the migration from REST to GraphQL` or `claude --agent enhanced-planner "Plan the migration from REST to GraphQL"`

### Research Agent

**Best for:** Web research with sources  
**Model:** sonnet (read-only)  
**Run:** `@research-agent Compare three job-queue libraries for Node` or `claude --agent research-agent "Compare three job-queue libraries for Node"`

### Task Breakdown

**Best for:** Epics into estimated stories  
**Model:** sonnet  
**Run:** `@task-breakdown Break the reporting epic into stories with acceptance criteria` or `claude --agent task-breakdown "Break the reporting epic into stories with acceptance criteria"`

### Doc Generator

**Best for:** READMEs, API docs, diagrams  
**Model:** sonnet  
**Run:** `@doc-generator Write API docs for the public endpoints in src/api` or `claude --agent doc-generator "Write API docs for the public endpoints in src/api"`

## DevOps

### Docker Expert

**Best for:** Dockerfiles, multi-stage builds, image size  
**Model:** opus  
**Run:** `@docker-expert Shrink the production image` or `claude --agent docker-expert "Shrink the production image"`

### Kubernetes Expert

**Best for:** Manifests, Helm, debugging pods  
**Model:** opus  
**Run:** `@kubernetes-expert Why is the api pod in CrashLoopBackOff?` or `claude --agent kubernetes-expert "Why is the api pod in CrashLoopBackOff?"`

### CI/CD Expert

**Best for:** GitHub Actions, GitLab CI, Azure DevOps  
**Model:** opus  
**Run:** `@cicd-expert Add caching and a matrix build to the test workflow` or `claude --agent cicd-expert "Add caching and a matrix build to the test workflow"`

### Terraform Expert

**Best for:** Modules, state, safe plans  
**Model:** opus  
**Run:** `@terraform-expert Split the monolithic stack into modules` or `claude --agent terraform-expert "Split the monolithic stack into modules"`

## Automation

### n8n Expert

**Best for:** Builds, validates and tests n8n workflows and n8n Agents through the `n8n` MCP server (`mcpServers: [n8n]`). Starts with `get_instance_context`, reads the SDK reference and best practices before writing, then searches nodes, creates or updates, validates and tests. Never publishes or executes a workflow without your go-ahead; credentials by reference only. If the server is down it writes importable workflow JSON  
**Model:** opus  
**Run:** `@n8n-expert Build a workflow that posts new GitHub issues to Slack` or `claude --agent n8n-expert "Build a workflow that posts new GitHub issues to Slack"`

## Debugging

### Debug Detective

**Best for:** Root-cause analysis from errors and stack traces  
**Model:** opus (effort: xhigh, read-only, memory: project)  
**Run:** `@debug-detective Find why the nightly job fails only on the first of the month` or `claude --agent debug-detective "Find why the nightly job fails only on the first of the month"`

### Performance Optimizer

**Best for:** Profiling and bottleneck analysis  
**Model:** opus (effort: xhigh, read-only)  
**Run:** `@performance-optimizer Find the bottleneck in the dashboard load` or `claude --agent performance-optimizer "Find the bottleneck in the dashboard load"`

### Legacy Modernizer

**Best for:** Incremental migrations and tech-debt plans  
**Model:** opus (effort: xhigh, memory: project)  
**Run:** `@legacy-modernizer Plan a move from jQuery to React, one page at a time` or `claude --agent legacy-modernizer "Plan a move from jQuery to React, one page at a time"`

## Choosing an agent

1. One language or tool: use that expert (`python-expert`, `postgres-expert`, `docker-expert`).
2. Review without changes: `code-reviewer`, `security-auditor`, `debug-detective`, `performance-optimizer` (all read-only).
3. A feature spanning UI, API and data: `fullstack-expert`, or `orchestrator` if it also needs tests and review.
4. Planning only: `enhanced-planner`, then `task-breakdown`.
5. Unsure: start with `orchestrator` and let it pick.

`orchestrator` and `workflow-manager` run as the main thread (`model: inherit`) and spawn other agents with the `Agent` tool.
