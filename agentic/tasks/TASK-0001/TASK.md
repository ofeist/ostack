# Task: Document runtime file lifecycle for workflow

## ID
TASK-0001

Use the next available `TASK-####` identifier from the existing set under `agentic/tasks/` whose basename matches `TASK-####` or starts with `TASK-####-`.

## Status
`ready`

When a task is first opened, start at `draft`. Move to `ready` only after explicit approval to begin implementation. Move to `in_progress` only when Builder-Organizer actually begins execution. Use `done` only when the task is actually complete. When a task reaches `done`, clear the task-level `next_actor` in `tasks.yaml` to `null`.

Reopen the same task only if the goal and scope are still the same. Create a new task id for a new slice, a changed goal, a material scope expansion, or independently tracked follow-up work.

## Branch
`docs/task-0001-runtime-file-lifecycle`

## Roadmap Reference
Optional:
- workflow runtime lifecycle clarification

## Goal
Define and document the runtime file policy so the repo clearly distinguishes `*.example.yaml` files from live runtime files, states what is committed versus not committed, and explains how runtime files are initialized on a new repo or a new machine.

## Context
The workflow currently includes both committed example files and live runtime files under `agentic/`, but the lifecycle policy is not yet explicit enough. The repo needs one clear explanation of:
- how `*.example.yaml` relates to `*.yaml`
- which files are meant to be committed
- how runtime files should be initialized in a fresh environment

## Scope
This slice is expected to cover:
- documentation that defines the policy for `*.example.yaml` versus live runtime files
- documentation that explicitly states which runtime-related files are committed versus not committed
- documentation that explains how runtime files are initialized on a new repo clone or a new machine
- only the minimum doc updates required to keep the policy description truthful and internally consistent

## Out of Scope
What must not be touched in this slice?
- unrelated workflow redesign
- task execution semantics unrelated to runtime file lifecycle
- broader multi-agent policy changes outside the runtime file lifecycle topic
- changes to `agentic/bootstrap-runtime.sh`
- changes to repo ignore behavior such as `.gitignore`
- broader workflow or mechanical cleanup
- non-documentation alignment work unless it is absolutely required to keep the docs truthful

## Dependencies / Prerequisites
What must already exist or be merged first?
- current workflow scaffold under `agentic/`
- agreement on the intended policy for whether live runtime files are committed, local-only, or mixed by file

## Constraints
Examples:
- minimal diff
- docs/policy only
- preserve the current workflow structure
- do not start implementation until the task is explicitly moved to `ready`
- do not introduce script, ignore-file, or other mechanical changes in this slice

## Blast Radius
`small`

## Rollout Class
`local`

## Risks
Known risks or design concerns.
- documentation may conflict with current repo reality if commit policy is not settled first
- a clear policy may reveal follow-up mechanical work, but that follow-up should be split into a later task

## Artifacts To Update
Which code, docs, config, or workflows are expected to change?
- `agentic/README.md`
- supporting workflow docs under `agentic/` only where the runtime file policy must be documented or clarified

## Verification Plan
Which tests / commands / checks should be run?
- read-through validation that runtime lifecycle statements are consistent across workflow docs
- verify the written initialization guidance matches the current documented bootstrap path without changing the script

## Slice Readiness Check
A task should usually move from `draft` to `ready` only if:
- the goal is clear
- the scope is narrow
- dependencies are known
- branch and worktree intent are clear
- rollout class is chosen when relevant
- verification is concrete
- open questions are either resolved or explicitly accepted

Ready-state note:
- branch and worktree intent are clear
- the runtime file commit policy will be resolved within this approved docs/policy slice

## Coordination Notes
Runtime coordination belongs in `state.yaml`, `tasks.yaml`, and task-local handoff files.

## Open Questions
Only if relevant while shaping the task.
- Should live runtime files such as `agentic/state.yaml`, `agentic/tasks.yaml`, and `agentic/agent-config.yaml` be committed in normal repo use, or should they be treated as machine-local runtime state?
- If the policy differs by file, which live runtime files are committed versus ignored?

## Rollout Notes
Only if relevant.
- keep this as a docs-only policy slice; any mechanical or workflow-alignment follow-up should be opened separately if needed

## Done When
Concrete acceptance criteria.
- the workflow docs clearly define the role of `*.example.yaml` files versus live runtime files
- the repo clearly states which runtime files are committed and which are not
- the initialization path for a new repo or new machine is documented in the workflow docs
- the task is completed without changing scripts, ignore rules, or unrelated workflow mechanics
