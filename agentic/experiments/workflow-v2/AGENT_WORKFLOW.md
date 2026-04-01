# AGENT_WORKFLOW.md

This document defines the minimal multi-agent workflow for this repository.

## Recommended placement

Since the repo already has an `agentic/` folder, the cleanest default is:

```text
agentic/
  experiments/
    workflow-v2/
      AGENT_WORKFLOW.md
      state.example.yaml
      tasks.example.yaml
      handoffs/
        TS-EXAMPLE.md
```

If this experiment graduates into the active default later, the cleaner long-term shape would be:

```text
agentic/
  README.md
  workflow/
    AGENT_WORKFLOW.md
    state.example.yaml
    tasks.example.yaml
    handoffs/
      TS-EXAMPLE.md
```

## Recommendation

Do **not** put `v2` in the filename unless you expect multiple active versions in parallel.

Prefer:

```text
agentic/experiments/workflow-v2/AGENT_WORKFLOW.md
```

Instead of:

```text
agentic/AGENT_WORKFLOW-v2.md
```

### Why
- easier to reference from prompts and docs
- avoids version suffix creep
- keeps workflow docs grouped together
- lets you version through Git, not filenames

## When a `v2/` folder does make sense

Use a versioned folder only if you truly want to keep two workflow variants alive at the same time, for example:

```text
agentic/
  workflow-v1/
  workflow-v2/
```

or

```text
agentic/
  experiments/
    workflow-v2/
```

That is useful for temporary experimentation, but not as the default long-term structure.

## Preferred structure

```text
agentic/
  README.md
  workflow/
    AGENT_WORKFLOW.md
    state.example.yaml
    tasks.example.yaml
    handoffs/
      TS-EXAMPLE.md
```

## What goes where

### `agentic/experiments/workflow-v2/README.md`
Short overview:
- what this folder is for
- where the experimental workflow spec lives
- where the example state, tasks, and handoffs live

### `agentic/experiments/workflow-v2/AGENT_WORKFLOW.md`
Main workflow spec:
- roles
- global state
- task registry
- handoff rules
- worktree policy
- completion signaling
- task lifecycle

### `agentic/experiments/workflow-v2/state.example.yaml`
Minimal example of global state.

### `agentic/experiments/workflow-v2/tasks.example.yaml`
Minimal example of task registry.

### `agentic/experiments/workflow-v2/handoffs/TS-EXAMPLE.md`
Minimal example of one task handoff file.

## Rule of thumb

- one active workflow -> plain `AGENT_WORKFLOW.md`
- multiple experimental workflow versions -> separate versioned folders
- avoid `-v2` in filenames unless there is a real need

## Workflow spec

## Goal

Provide a simple, structured way for multiple agents to collaborate without:
- overwriting each other's work
- losing task state
- reviewing the wrong commit
- mixing communication across tasks

This workflow starts small and can be expanded later.

---

## Core Principles

- One source of truth for global coordination
- One registry for active tasks
- One handoff file per task
- One worktree per task or review stream when parallel work is needed
- The coordinator does not guess task completion
- Task completion must be explicitly signaled

---

## Roles

### Coordinator
Responsible for:
- maintaining global state
- maintaining task registry
- assigning next actions
- deciding when work moves to review or QA
- deciding what gets integrated into the canonical branch

The coordinator is the control plane of the workflow.

### Builder
Responsible for:
- implementing the requested change
- working in the assigned branch/worktree
- leaving a completion signal in the task handoff

### Reviewer
Responsible for:
- reviewing code or logic
- reporting findings clearly
- signaling approval or required changes

### QA
Responsible for:
- validating expected behavior
- reporting pass/fail clearly
- attaching reproduction notes when needed

---

## Repository Structure

```text
agentic/
  workflow/
    AGENT_WORKFLOW.md
    state.example.yaml
    tasks.example.yaml
    handoffs/
      TS-EXAMPLE.md
```

### `state.example.yaml`
Global coordination snapshot.

Contains:
- current objective
- canonical branch
- canonical commit
- active focus
- blockers
- who is next

### `tasks.example.yaml`
Registry of active tasks.

Contains per task:
- id
- title
- status
- owner
- branch
- worktree
- next_action

### `handoffs/<task-id>.md`
Append-only communication log for one task.

Used for:
- implementation handoff
- review findings
- QA results
- blocker reports
- resolution notes

---

## Minimal State Format

```yaml
session:
  objective: "Complete TS12-03 and send to QA"
  canonical_branch: "feat/iter12-ts03"
  canonical_commit: "def5678"
  updated_at: "2026-03-31T22:00:00+02:00"

focus_task: "TS12-03"
blockers: []
next_actor: "reviewer-a"
```

---

## Minimal Task Registry Format

```yaml
tasks:
  - id: TS12-03
    title: "Console presets UX"
    status: "in_review"
    owner: "builder-a"
    branch: "feat/iter12-ts03"
    worktree: "../worktrees/gaas-ts12-03"
    next_action: "reviewer-a review"

  - id: TS12-05
    title: "Preset deployment smoke test"
    status: "todo"
    owner: "qa-a"
    branch: "feat/iter12-ts05"
    worktree: "../worktrees/gaas-ts12-05-qa"
    next_action: "wait for TS12-03 completion"
```

---

## Task Lifecycle

Recommended statuses:
- `todo`
- `in_progress`
- `in_review`
- `qa`
- `blocked`
- `done`

Suggested flow:

`todo -> in_progress -> in_review -> qa -> done`

If something fails:
- `in_review -> in_progress`
- `qa -> in_progress`
- any state -> `blocked`

---

## Handoff Rules

Each task gets exactly one handoff file:

```text
agentic/experiments/workflow-v2/handoffs/<task-id>.md
```

Rules:
- append-only
- short, structured entries
- include commit hash where relevant
- include explicit next action
- do not use the handoff file for general brainstorming

### Entry Template

```md
## YYYY-MM-DD HH:MM TZ | from -> to | task <ID> | branch <branch> | commit <hash> | type: <type>

Context:
- ...

Delta:
- ...

Files:
- ...

Risks / notes:
- ...

Next action:
- ...
```

### Common Types
- `implementation_done`
- `review_request`
- `finding`
- `approved`
- `qa_result`
- `blocked`
- `resolution`

---

## Completion Signaling

The coordinator must not guess whether an agent is finished.

An agent is considered done only when it leaves an explicit completion signal in the task handoff.

Minimum completion signal:

```md
Status: done
Outcome: ready_for_review
Commit: abc1234
Next: reviewer-a
```

Examples:
- Builder: `Outcome: ready_for_review`
- Reviewer: `Outcome: approved` or `changes_requested`
- QA: `Outcome: pass` or `fail`

A commit alone is not enough.

---

## Worktree Policy

Use separate worktrees when parallel work is needed.

Recommended pattern:
- one main worktree for implementation
- separate review/QA worktrees when reviewers or QA need isolation

Example naming:

```text
worktrees/
  gaas-ts12-03
  gaas-ts12-03-review-a
  gaas-ts12-03-review-b
  gaas-ts12-03-qa
```

Example commands:

```bash
git worktree add ../worktrees/gaas-ts12-03 feat/iter12-ts03
git worktree add -b review/ts12-03-a ../worktrees/gaas-ts12-03-review-a feat/iter12-ts03
git worktree add -b qa/ts12-03-a ../worktrees/gaas-ts12-03-qa feat/iter12-ts03
```

---

## Coordinator Rules

The coordinator:
- updates global state
- updates task registry
- creates task handoff files
- assigns next actor
- decides when a task moves to review or QA
- decides when a task is done

The coordinator should not infer completion from silence, partial edits, or dirty worktrees.

---

## Minimal Operating Procedure

### 1. Start a task
Coordinator:
- adds task to task registry
- creates handoff file
- assigns branch/worktree
- updates global state

### 2. Build
Builder:
- implements change
- leaves handoff entry with commit + next step

### 3. Review
Reviewer:
- reads task handoff
- reviews assigned scope
- leaves findings or approval

### 4. QA
QA:
- validates behavior
- leaves pass/fail result

### 5. Close
Coordinator:
- updates task status to `done`
- updates global state
- optionally removes temporary worktrees

---

## Recommended First Version

Start simple:
- 1 coordinator
- 1 builder
- 1 reviewer
- optional QA
- only active tasks in the registry
- short handoff entries only

Do not overengineer the first version.
