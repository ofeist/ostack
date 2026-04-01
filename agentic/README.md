# Agentic Workflow

This is the active workflow scaffold for this repository.

The workflow is task-centric, worktree-aware, and multi-agent aware from the start, even when used by one person or one agent.

## Active Structure

```text
agentic/
  README.md
  state.example.yaml
  tasks.example.yaml
  agent-config.example.yaml
  prompts/
    BUILDER_ORGANIZER_PROMPT.txt
  workflows/
    WORKTREE_POLICY.md
    PORTING.md
  tasks/
    _template/
      TASK.md
      handoffs/
        0001-builder-organizer-a-start.md
```

Runtime files for a live repo may later look like:

```text
agentic/
  state.yaml
  tasks.yaml
  agent-config.yaml
  tasks/
    TASK-0001/
      TASK.md
      handoffs/
        0001-builder-organizer-a-start.md
```

## Core Model

- `state.yaml` is the global coordination snapshot.
- `tasks.yaml` is the registry of active tasks.
- `agent-config.yaml` enables roles and documents startup conventions for those roles.
- `tasks/<task-id>/TASK.md` holds task scope and acceptance criteria.
- `tasks/<task-id>/handoffs/` holds task-local coordination history.
- one handoff event = one file
- one active branch has one writer at a time
- parallel work is allowed only when write scopes do not overlap

## Rules

- all new tasks must use `agentic/tasks/<task-id>/`
- legacy top-level handoffs are reference-only
- `agent-config.yaml` does not assign work
- `tasks.yaml` is the authoritative source for task assignment and positioning

## Metadata Precedence

- `state.next_actor` is the global next actor
- `tasks[].next_actor` is the next actor for that specific task
- task routing comes primarily from `tasks.yaml`
- `agent-config.yaml` defines enabled role configuration and optional prompt metadata

## Naming Conventions

- worktrees use `../worktrees/<repo>-<task-id>-<actor-id>`
- branches use `feature/<task-id>-<slug>`
- task handoff files use `NNNN-<actor-id>-<event>.md`

## Agent Config Note

`agent-config.yaml` runtime handling is not finalized yet.

For now, the workflow starts from `agentic/agent-config.example.yaml`.

Future repos or teams may choose one of these models:
- committed shared runtime config
- local runtime config
- shared base plus local override

This should be refined after real usage, not overdesigned up front.

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
3. Copy `agentic/agent-config.example.yaml` to `agentic/agent-config.yaml` if role activation config has not been initialized yet.
4. Copy `agentic/tasks/_template/` to `agentic/tasks/TASK-0001/`.
5. Fill in `TASK.md`.
6. Create or update `tasks.yaml`.
7. Create or update `state.yaml`.
8. Work in the assigned branch and worktree.
9. Write numbered handoff files under `handoffs/`.
10. Hand off or close the task explicitly.

## Startup Model

An agent should initialize in this order:

1. Read `agent-config.yaml` to see which roles are enabled and any optional prompt metadata for those roles.
2. Read `tasks.yaml` to determine task ownership, branch, worktree, and task-level next actor.
3. Read `state.yaml` to understand the global objective, blockers, and global next actor.
4. Read the selected task folder to execute the task and record task-local handoffs.

## Legacy Material

The following remain in the repo as reference material during migration:
- legacy v1 task files and handoff examples
- `agentic/experiments/workflow-v2/`

New workflow changes should use the structure described in this file.
