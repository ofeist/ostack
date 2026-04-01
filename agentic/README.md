# Agentic Workflow

This is the active workflow scaffold for this repository.

The workflow is task-centric, worktree-aware, and multi-agent aware from the start, even when used by one person or one agent.

## Active Structure

```text
agentic/
  README.md
  state.example.yaml
  tasks.example.yaml
  prompts/
    BUILDER_ORGANIZER_PROMPT.txt
  workflows/
    WORKTREE_POLICY.md
    PORTING.md
  tasks/
    _template/
      TASK.md
      handoffs/
        0001-example.md
```

Runtime files for a live repo may later look like:

```text
agentic/
  state.yaml
  tasks.yaml
  tasks/
    TASK-0001/
      TASK.md
      handoffs/
        0001-builder-organizer.md
```

## Core Model

- `state.yaml` is the global coordination snapshot.
- `tasks.yaml` is the registry of active tasks.
- `tasks/<task-id>/TASK.md` holds task scope and acceptance criteria.
- `tasks/<task-id>/handoffs/` holds task-local coordination history.
- one handoff event = one file
- one active branch has one writer at a time
- parallel work is allowed only when write scopes do not overlap

## Rules

- all new tasks must use `agentic/tasks/<task-id>/`
- legacy top-level handoffs are reference-only

## Initial Role

The initial active role is `Builder-Organizer`.

That role:
- implements the slice
- keeps task coordination current
- writes explicit handoff files for checkpoints, blockers, review requests, and completion
- follows the worktree policy

## Minimal Flow

1. Copy `agentic/state.example.yaml` to `agentic/state.yaml` if runtime state has not been initialized yet.
2. Copy `agentic/tasks.example.yaml` to `agentic/tasks.yaml` if the task registry has not been initialized yet.
3. Copy `agentic/tasks/_template/` to `agentic/tasks/TASK-0001/`.
4. Fill in `TASK.md`.
5. Create or update `tasks.yaml`.
6. Create or update `state.yaml`.
7. Work in the assigned branch and worktree.
8. Write numbered handoff files under `handoffs/`.
9. Hand off or close the task explicitly.

## Legacy Material

The following remain in the repo as reference material during migration:
- legacy v1 task files and handoff examples
- `agentic/experiments/workflow-v2/`

New workflow changes should use the structure described in this file.
