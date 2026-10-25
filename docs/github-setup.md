# GitHub Repository Setup

Checklist for publishing and maintaining this repository.

## Repository settings

- **Description**: "37 sub-agents for Claude Code: orchestration, full-stack, language experts, testing, design, DevOps, debugging."
- **Topics**: `claude-code`, `claude`, `sub-agents`, `ai-agents`, `developer-tools`, `agent-library`, `automation`
- **Features**: enable Issues and Discussions; disable Wiki and Projects unless used.
- **Merge**: allow squash merges; delete branches after merge.

The repository name predates the Claude Code conversion. Renaming it is optional; GitHub redirects the old URL.

## Branch protection (`main`)

1. Require a pull request before merging (1 approval).
2. Require the **Validate Agents** status check to pass.
3. Require branches to be up to date.
4. Block force pushes and deletions.

## Continuous integration

`.github/workflows/validate.yml` runs `scripts/validate-agents.sh` on pushes and pull requests and expects 37 agents. Run the same check locally:

```bash
bash scripts/validate-agents.sh
```

Optional: a Markdown lint workflow, and an auto-label workflow keyed on the `agents/<category>/` path.

## Labels

- Type: `bug`, `enhancement`, `documentation`, `question`
- Category: `orchestration`, `fullstack`, `coding`, `testing`, `design`, `productivity`, `devops`, `automation`, `debugging`
- Status: `needs-review`, `needs-testing`, `ready-to-merge`
- New agents: `new-agent`

## Discussions

Categories: Announcements, Ideas (agent requests), Q&A, Show and Tell, General.

## Issue and PR templates

Already in `.github/ISSUE_TEMPLATE/`: `bug_report.md`, `feature_request.md`, `new_agent.md`.

## Releasing

1. Run `bash scripts/validate-agents.sh` and `bash scripts/pre-launch-check.sh`.
2. Check `.claude-plugin/plugin.json` has the right version.
3. Tag and release:

   ```bash
   git tag -a v1.0.0 -m "37 sub-agents"
   git push origin v1.0.0
   ```

4. Release notes: counts by category, install routes (user scope, project scope, plugin), link to the Getting Started guide.

## Security

- Enable secret scanning, push protection and Dependabot alerts.
- Keep a `SECURITY.md` with a private contact and a response time.
- Never commit tokens. Agents refer to environment variable names only.

## Launch checklist

- [ ] README renders; links work
- [ ] `docs/` reviewed
- [ ] Validation passes with 37 agents
- [ ] `/agents` lists all agents after copying `agents/` into `.claude/agents/`
- [ ] Description, topics and license set
- [ ] Release created
