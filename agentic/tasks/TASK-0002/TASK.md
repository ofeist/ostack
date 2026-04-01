# Task: Clean up workflow state after first Builder-Reviewer loop

## ID
TASK-0002

Use the next available `TASK-####` identifier from the existing set under `agentic/tasks/` whose basename matches `TASK-####` or starts with `TASK-####-`.

## Status
`done`

When a task is first opened, start at `draft`. Move to `ready` only after explicit approval to begin implementation. Move to `in_progress` only when Builder-Organizer actually begins execution. Use `done` only when the task is actually complete. When a task reaches `done`, clear the task-level `next_actor` in `tasks.yaml` to `null`.

Reopen the same task only if the goal and scope are still the same. Create a new task id for a new slice, a changed goal, a material scope expansion, or independently tracked follow-up work.

## Branch
`chore/task-0002-cleanup-workflow-state`

## Roadmap Reference
Optional:
- post-first-loop workflow state cleanup

## Goal
Clean up narrow administrative workflow state after the first Builder-Reviewer loop so the runtime baseline reflects the actual current repo state cleanly.

## Context
The repository has completed its first Builder-Reviewer loop on `TASK-0001`. Before opening broader follow-up work, the workflow state should be checked for:
- stale or inconsistent task/runtime state
- superseded or duplicate review handoffs
- whether `agentic/tasks.yaml` and `agentic/state.yaml` still reflect the real current baseline

This cleanup is administrative only and should not expand into broader workflow restructuring.

## Scope
This slice is expected to cover:
- checking current task/runtime files for stale or inconsistent administrative state
- checking whether any review handoff artifacts are superseded, duplicated, or misleading in the current task-local history
- updating `agentic/tasks.yaml`, `agentic/state.yaml`, or task-local workflow artifacts only if needed to restore a clean current baseline
- documenting the resulting baseline clearly if a small task-local workflow note is needed

## Out of Scope
What must not be touched in this slice?
- broader workflow redesign
- Reviewer or QA feature expansion
- moving runtime files out of `agentic/`
- non-administrative product or documentation changes unrelated to workflow state cleanup
- reopening or re-scoping the accepted `TASK-0001` slice

## Dependencies / Prerequisites
What must already exist or be merged first?
- merged `TASK-0001` branch history on `main`
- current runtime/task files under `agentic/`

## Constraints
Examples:
- minimal diff
- administrative cleanup only
- preserve accepted `TASK-0001` intent and recorded override decisions
- do not start implementation until the task is explicitly moved to `ready`

## Blast Radius
`small`

## Rollout Class
`local`

## Risks
Known risks or design concerns.
- cleanup could accidentally rewrite useful workflow history if the slice is not kept strictly administrative
- task/runtime state may look inconsistent in ways that are intentional and should be preserved

## Artifacts To Update
Which code, docs, config, or workflows are expected to change?
- `agentic/tasks.yaml`
- `agentic/state.yaml`
- task-local handoff files under `agentic/tasks/TASK-0001/handoffs/` only if administrative cleanup is actually required
- `agentic/tasks/TASK-0002/TASK.md`

## Verification Plan
Which tests / commands / checks should be run?
- read-through validation that `tasks.yaml`, `state.yaml`, and task-local handoff history describe the same current baseline
- verify any retained review handoffs are still intentionally part of the accepted task history

## Slice Readiness Check
A task should usually move from `draft` to `ready` only if:
- the goal is clear
- the scope is narrow
- dependencies are known
- branch and worktree intent are clear
- rollout class is chosen when relevant
- verification is concrete
- open questions are either resolved or explicitly accepted

Current draft note:
- branch and worktree intent are clear
- the main readiness question is whether any existing task-local review handoffs should be preserved as-is or cleaned up administratively

Ready-state note:
- the cleanup slice is approved as a narrow administrative task
- execution has not started yet; no execution-start handoff should be written until Builder-Organizer actually begins work

Completion note:
- current runtime state is consistent with the actual baseline after the first Builder-Reviewer loop
- TASK-0001 review handoff `0003` remains intentionally preserved as historical context because it is explicitly superseded by override handoff `0004`

## Coordination Notes
Runtime coordination belongs in `state.yaml`, `tasks.yaml`, and task-local handoff files.

## Open Questions
Only if relevant while shaping the task.
- Should superseded review handoffs remain in task history when they are intentionally overridden, or should this cleanup normalize that history further?
- Does `state.yaml` need a more explicit post-task baseline beyond `Await next task opening`, or is the current objective already sufficient?

## Rollout Notes
Only if relevant.
- keep this as a narrow cleanup task; any structural workflow follow-up should be opened separately

## Done When
Concrete acceptance criteria.
- the current runtime/task files reflect the real current baseline without stale or misleading administrative state
- any retained review handoff history is either confirmed intentional or cleaned up narrowly
- the cleanup stays administrative and does not expand into broader workflow refactoring
