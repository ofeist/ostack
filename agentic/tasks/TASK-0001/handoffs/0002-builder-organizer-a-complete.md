# Handoff 0002

## From
builder-organizer-a

## To
builder-organizer-a

## Task
TASK-0001

## Branch
docs/task-0001-runtime-file-lifecycle

## Worktree
worktrees/ostack-task-0001-builder-organizer-a

## Type
completion

## Summary
Completed the docs-only runtime file lifecycle policy slice.

## Context
The workflow docs now define:
- the role of committed `*.example.yaml` scaffold files
- the role of committed live runtime files for an active repo
- what is and is not portable when the workflow is moved to a different repo
- how runtime files are initialized in a fresh repo and how an already initialized repo should be used on a new machine

## Artifacts Changed
- `agentic/README.md`
- `agentic/workflows/PORTING.md`
- `agentic/tasks/TASK-0001/TASK.md`
- `agentic/tasks.yaml`
- `agentic/state.yaml`

## Verification
- read-through validation across the updated workflow docs
- `bash agentic/bootstrap-runtime.sh` confirmed that existing live runtime files are not overwritten

## Risks / Notes
- this task intentionally did not change bootstrap scripts, ignore rules, or broader workflow mechanics
- any future mechanical follow-up should be opened as a separate task

## Outcome
done

## Next Actor
builder-organizer-a
