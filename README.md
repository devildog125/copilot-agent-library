# Claude Code Agent Library

**37 sub-agents for [Claude Code](https://code.claude.com)**, each a single Markdown file you can copy, edit and version. Every agent has a focused job, a model and tool list that fit it, and a defined way of reporting back.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Agents](https://img.shields.io/badge/Agents-37-green.svg)](#agent-categories)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## Install

Pick one route.

**1. All projects** (user scope):

```bash
mkdir -p ~/.claude/agents
cp agents/*/*.agent.md ~/.claude/agents/
```

**2. One project** (commit it so your team gets it too):

```bash
mkdir -p .claude/agents
cp agents/coding/python-expert.agent.md .claude/agents/
```

**3. Plugin** (whole library; the manifest `.claude-plugin/plugin.json` names it `agent-library`). Load it from a local checkout:

```bash
claude --plugin-dir /path/to/this/repo
```

The marketplace route (`/plugin marketplace add <owner>/<repo>`, then `/plugin install agent-library@<marketplace>`) needs a `.claude-plugin/marketplace.json`, which this repo does not have yet.

Check the install with `/agents` inside a Claude Code session.

## Use

Inside a session, mention the agent:

```
@python-expert add type hints to utils.py
```

From a script or CI (headless; the agent runs as the main thread):

```bash
claude --agent python-expert "Add type hints to utils.py"
```

See [Invocation](docs/invocation.md) for when to use which.

---

## Agent Categories

### Orchestration (3 agents)

| Agent | Description |
|-------|-------------|
| [**orchestrator**](agents/orchestration/orchestrator.agent.md) | Splits a large task and delegates to specialists |
| [**workflow-manager**](agents/orchestration/workflow-manager.agent.md) | Sequential and parallel task execution |
| [**project-manager**](agents/orchestration/project-manager.agent.md) | Sprint planning and stakeholder coordination |

### Full-Stack Development (6 agents)

| Agent | Description |
|-------|-------------|
| [**frontend-developer**](agents/fullstack/frontend-developer.agent.md) | React/Vue/Angular, component architecture |
| [**backend-developer**](agents/fullstack/backend-developer.agent.md) | APIs, authentication, database integration |
| [**fullstack-expert**](agents/fullstack/fullstack-expert.agent.md) | End-to-end feature implementation |
| [**mobile-developer**](agents/fullstack/mobile-developer.agent.md) | React Native, Flutter, native iOS/Android |
| [**api-designer**](agents/fullstack/api-designer.agent.md) | REST principles, OpenAPI specs, versioning |
| [**database-architect**](agents/fullstack/database-architect.agent.md) | Schema design, normalization, query optimization |

### Language and Data Experts (7 agents)

| Agent | Description |
|-------|-------------|
| [**python-expert**](agents/coding/python-expert.agent.md) | Python 3.12+, typing, packaging, pytest |
| [**javascript-expert**](agents/coding/javascript-expert.agent.md) | Modern ES, TypeScript, Node.js |
| [**rust-expert**](agents/coding/rust-expert.agent.md) | Ownership, borrowing, async |
| [**go-expert**](agents/coding/go-expert.agent.md) | Concurrency patterns, error handling |
| [**java-expert**](agents/coding/java-expert.agent.md) | Spring Boot, Maven/Gradle, JUnit |
| [**sql-expert**](agents/coding/sql-expert.agent.md) | Vendor-neutral SQL, query tuning, migrations |
| [**postgres-expert**](agents/coding/postgres-expert.agent.md) | PostgreSQL: EXPLAIN, indexes, partitioning, VACUUM, locks, RLS |

### Testing and Quality (5 agents)

| Agent | Description |
|-------|-------------|
| [**e2e-tester**](agents/testing/e2e-tester.agent.md) | Playwright, Cypress, Selenium |
| [**ab-test-ideas**](agents/testing/ab-test-ideas.agent.md) | Hypotheses and experiment design |
| [**code-reviewer**](agents/testing/code-reviewer.agent.md) | Read-only pull request review |
| [**security-auditor**](agents/testing/security-auditor.agent.md) | Read-only vulnerability review, OWASP |
| [**test-generator**](agents/testing/test-generator.agent.md) | Unit and integration tests |

### Design and UI/UX (4 agents)

| Agent | Description |
|-------|-------------|
| [**uiux-designer**](agents/design/uiux-designer.agent.md) | User flows, wireframes, design review |
| [**figma-to-html**](agents/design/figma-to-html.agent.md) | Turns screenshots and exports (or a Figma MCP, if configured) into HTML/CSS/React |
| [**responsive-design**](agents/design/responsive-design.agent.md) | Mobile-first layout, accessibility |
| [**design-system**](agents/design/design-system.agent.md) | Component libraries, design tokens |

### Productivity (4 agents)

| Agent | Description |
|-------|-------------|
| [**enhanced-planner**](agents/productivity/enhanced-planner.agent.md) | Multi-step plans with dependencies |
| [**research-agent**](agents/productivity/research-agent.agent.md) | Read-only web research and synthesis |
| [**task-breakdown**](agents/productivity/task-breakdown.agent.md) | Epic decomposition and estimation |
| [**doc-generator**](agents/productivity/doc-generator.agent.md) | READMEs, API docs, diagrams |

### DevOps (4 agents)

| Agent | Description |
|-------|-------------|
| [**docker-expert**](agents/devops/docker-expert.agent.md) | Dockerfiles, multi-stage builds |
| [**kubernetes-expert**](agents/devops/kubernetes-expert.agent.md) | Manifests, Helm, troubleshooting |
| [**cicd-expert**](agents/devops/cicd-expert.agent.md) | GitHub Actions, GitLab CI, Azure DevOps |
| [**terraform-expert**](agents/devops/terraform-expert.agent.md) | Infrastructure as code, state |

### Automation (1 agent)

| Agent | Description |
|-------|-------------|
| [**n8n-expert**](agents/automation/n8n-expert.agent.md) | Builds and validates n8n workflows and agents through the `n8n` MCP server |

### Debugging (3 agents)

| Agent | Description |
|-------|-------------|
| [**debug-detective**](agents/debugging/debug-detective.agent.md) | Read-only root-cause analysis |
| [**performance-optimizer**](agents/debugging/performance-optimizer.agent.md) | Read-only profiling and bottleneck analysis |
| [**legacy-modernizer**](agents/debugging/legacy-modernizer.agent.md) | Migration strategy, tech-debt reduction |

---

## Examples

```bash
# One specialist, headless
claude --agent postgres-expert "Why is the orders report query slow? Use EXPLAIN (ANALYZE, BUFFERS)."

# A coordinator that delegates to other agents
claude --agent orchestrator "Add password reset: API endpoint, UI form, tests, security review"
```

The orchestrator delegates with the `Agent` tool (backend-developer, frontend-developer, test-generator, security-auditor) and returns one summary.

---

## Documentation

- [Getting Started](docs/getting-started.md): install and first run
- [Invocation](docs/invocation.md): `@name` in a session vs `claude --agent` in scripts
- [Agent Guide](docs/agent-guide.md): every agent, when to use it
- [Orchestration Patterns](docs/orchestration-patterns.md): multi-agent work
- [Best Practices](docs/best-practices.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Contributing](CONTRIBUTING.md) and [Testing](TESTING.md)

## License

MIT, see [LICENSE](LICENSE).

## Acknowledgments

Originally inspired by [github/awesome-copilot](https://github.com/github/awesome-copilot).
