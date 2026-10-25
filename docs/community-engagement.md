# Community and Feedback

How to run discussions and collect feedback for the library.

## GitHub Discussions

| Category | Type | Use |
|---|---|---|
| Announcements | Announcement | Releases, new agents |
| Ideas | Discussion | Agent requests and improvements |
| Q&A | Q&A | Choosing agents, getting better output |
| Show and Tell | Discussion | What people built |
| General | Discussion | Everything else |

### Welcome post (pin it)

> **Welcome to the Claude Code Agent Library.**
> Start with [Getting Started](getting-started.md). Install with `cp agents/*/*.agent.md ~/.claude/agents/`, then check `/agents`. Ask questions in Q&A, propose agents in Ideas, report bugs as Issues.

### Q&A starter answers

- **Which agent?** See the [Agent Guide](agent-guide.md). One domain: that expert. Several: `orchestrator`.
- **Better output?** Give file paths, the constraint and what "done" means. See [Troubleshooting](troubleshooting.md).
- **Multi-agent?** See [Orchestration Patterns](orchestration-patterns.md).

## Feedback channels

1. **Discussions** for questions and ideas.
2. **Issues** for bugs (`bug_report.md`), features (`feature_request.md`) and new agents (`new_agent.md`).
3. **Pull requests** following [CONTRIBUTING.md](../CONTRIBUTING.md).
4. **Optional survey**, quarterly, with these questions:
   - Which agents do you use most?
   - Which invocation style: `@name` in a session or `claude --agent` in scripts?
   - What is missing?
   - Anything wrong or out of date?

## Roadmap approach

- Keep the roadmap as a pinned Discussion or `ROADMAP.md`.
- Group ideas by votes and by category gaps.
- Mark items "planned", "in progress" or "shipped"; do not promise dates.

## Metrics worth tracking

- Stars, forks, clones
- Open and closed issues, time to first response
- Pull requests merged, new contributors
- Which agents are requested most

Report what you measured; leave out numbers you cannot source.

## Moderation

Follow [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md). Do not ask people to post prompts that contain secrets, tokens or personal data, and remove them if they appear.

## Recognition

- Credit contributors in release notes.
- Feature good community agents or workflows in Show and Tell.
