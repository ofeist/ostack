# Task: Bootstrap Live Runtime Workflow Files

## ID
TASK-0005

Use the next available `TASK-####` identifier from the existing set under `agentic/tasks/` whose basename matches `TASK-####` or starts with `TASK-####-`.

## Status
`done`

## Branch
`feature/task-0005-bootstrap-runtime-files`

## Goal
Initialize the live workflow runtime files from the committed example files with a minimal bootstrap flow that is readable and refuses to overwrite existing runtime files silently.

## Context
The repository has committed example files for `state`, `tasks`, and `agent-config`, but no live runtime files yet. The first live task should establish a practical bootstrap path and leave the live runtime state aligned to the current task branch, worktree, and actor.

## Scope
- add a minimal bootstrap script for runtime file initialization
- initialize `agentic/state.yaml` from `agentic/state.example.yaml`
- initialize `agentic/tasks.yaml` from `agentic/tasks.example.yaml`
- initialize `agentic/agent-config.yaml` from `agentic/agent-config.example.yaml`
- update the live runtime files so they reflect `TASK-0005`
- create task-local handoff files for this task

## Out of Scope
- listener or watcher automation
- reviewer, QA, or coordinator runtime behavior
- legacy workflow cleanup
- unrelated workflow refactors

## Dependencies / Prerequisites
- committed example files already exist under `agentic/`
- active workflow docs and Builder-Organizer prompt are already committed

## Constraints
Examples:
- minimal diff
- no silent overwrite of existing runtime files
- keep the bootstrap flow readable and practical

## Blast Radius
`small`

## Risks
Known risks or design concerns.
- the first committed runtime files establish an initial working model for `agent-config.yaml`, even though long-term runtime handling is still intentionally deferred
- copying examples verbatim would leave task and session context stale, so the initialized files must be updated to match the live task

## Artifacts To Update
Which code, docs, config, or workflows are expected to change?
- `agentic/bootstrap-runtime.sh`
- `agentic/README.md`
- `agentic/state.yaml`
- `agentic/tasks.yaml`
- `agentic/agent-config.yaml`
- `agentic/tasks/TASK-0005/`

## Verification Plan
Which tests / commands / checks should be run?
- run `bash agentic/bootstrap-runtime.sh` once with no runtime files present
- rerun `bash agentic/bootstrap-runtime.sh` and confirm it refuses to overwrite existing runtime files
- validate `agentic/state.yaml`, `agentic/tasks.yaml`, and `agentic/agent-config.yaml` with a YAML parser

## Coordination Notes
Runtime coordination belongs in `state.yaml`, `tasks.yaml`, and task-local handoff files.

## Done When
Concrete acceptance criteria.
- `agentic/bootstrap-runtime.sh` creates the three runtime files from examples when they do not exist
- rerunning the script does not overwrite existing runtime files
- live runtime files exist and reflect `TASK-0005`, `feature/task-0005-bootstrap-runtime-files`, and `worktrees/ostack-task-0005-builder-organizer-a`
- task-local handoff history exists for task start and completion
