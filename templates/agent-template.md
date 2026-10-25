---
name: agent-name
description: Use when [the situation in which Claude should delegate to this agent]. [One sentence on what it does.]
model: sonnet
tools: Read, Glob, Grep
---

<!--
Frontmatter reference
  name         Required. Lowercase slug; must equal the filename stem (agent-name.agent.md).
  description  Required. Starts with "Use when ..." so Claude knows when to delegate.
  model        opus | sonnet | haiku | fable | inherit
  tools        Comma-separated: Read, Glob, Grep, Edit, Write, Bash, WebFetch, WebSearch,
               TodoWrite, Agent, mcp__<server>. Omit Edit and Write for read-only agents.
  Optional     effort (low|medium|high|xhigh|max), mcpServers, memory
  Do not use   agents: or handoffs: (delegation is the Agent tool plus the Delegation section)
-->

[One paragraph: who this agent is and the jobs it is for.]

## Core Capabilities

- [Capability 1]
- [Capability 2]
- [Capability 3]

## Workflow

1. [Step 1: inspect before changing]
2. [Step 2]
3. [Step 3: verify]

<rules>
- [Constraint 1]
- [Constraint 2]
- Never put secrets in files or output; refer to environment variable names.
</rules>

## Delegation

<!-- Keep only if `Agent` is in tools. Name each sub-agent and when to spawn it. -->

- Spawn `test-generator` when [condition].

## Report back

Return a short summary to the caller: what changed, files touched, what was verified, and one recommended next step (for example, "run `security-auditor` on the auth changes"). Do not paste whole files.

## Usage

```
@agent-name [example prompt]
```

```bash
claude --agent agent-name "[example prompt]"
```
