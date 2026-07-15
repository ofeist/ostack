# ostack — Agentic Orchestration Stack

A file-based workflow for coordinating AI coding agents (and humans) on one
repository — task-centric, worktree-aware, and reviewable by design.

No server, no database, no framework lock-in: coordination state lives in the
repo as YAML and markdown, so every decision, handoff, and review is
git-auditable and works with any coding agent (Claude Code, Codex, OpenCode, …).

## Why

Letting multiple coding agents loose on one repo fails in predictable ways:
agents step on each other's changes, scope creeps mid-task, and nobody can
reconstruct afterwards who decided what. ostack fixes this with three rules:

1. **One active branch has one writer at a time.** Parallel work is allowed
   only when write scopes don't overlap, each in its own git worktree.
2. **Nothing gets implemented without an approval gate.** Tasks open as
   `draft` and are executed only after being explicitly moved to `ready`.
3. **Every coordination event is a committed file.** One handoff = one
   markdown file in the task folder — checkpoints, review verdicts, blockers.

## Roles

| Role | Does | Doesn't |
|---|---|---|
| **Builder-Organizer** | implements the slice, keeps task state current, writes handoffs | start work before a task is `ready` |
| **Reviewer** | reviews the slice against the task contract, writes verdicts (`approve` / `changes_requested` / `blocked`) | implement or change scope |
| **QA** | checks verification quality and operational readiness (`pass` / `issues_found` / `blocked`) | repeat the Reviewer's job; read-only by default |

Each role initializes from its own prompt under `agentic/prompts/`.

## Core model

```text
agentic/
  state.yaml            # global coordination snapshot (objective, blockers, next actor)
  tasks.yaml            # task registry — authoritative for assignment & routing
  agent-config.yaml     # which roles are enabled + startup conventions
  prompts/              # role prompts: Builder-Organizer, Reviewer, QA
  workflows/            # worktree policy, porting guide
  tasks/TASK-0001/
    TASK.md             # scope + acceptance criteria
    handoffs/           # one file per coordination event
```

Task lifecycle: `draft` → *(explicit approval)* → `ready` → `in_progress` →
review/QA → `done`. Tasks follow a **thin-slice rule**: small enough that the
goal is clear, the blast radius is low, and one branch/worktree covers it.

## Quickstart

Port the workflow into your repo, then initialize the runtime state:

```bash
cp -r agentic/ your-repo/agentic/        # see agentic/PORTING.md
cd your-repo
bash agentic/bootstrap-runtime.sh        # creates live state from *.example.yaml, never overwrites
```

Then point your coding agent at a role, e.g.:

```text
Initialize from `agentic/prompts/init-builder-organizer.md`. Do not start implementation.
```

Full workflow reference: [`agentic/README.md`](agentic/README.md).

## Related projects

- [agentarium](https://github.com/ofeist/agentarium) — agent registry:
  capability-based discovery and composition of agents.
- [pr-review-core](https://github.com/ofeist/pr-review-core) — the review
  engine: turns git diffs into stable review markdown in any CI.
- [hermetic-agentarium](https://github.com/ofeist/hermetic-agentarium) —
  sanitized agent profiles and skills for controlled coding workflows.

## Status

Actively used as the coordination layer for my own projects. The workflow
described in `agentic/README.md` is v2; legacy v1 prompts and experiments
remain in the repo as reference.

## License

[MIT](LICENSE)
