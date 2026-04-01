# Porting The Workflow

Port the workflow skeleton and templates only.

## Copy By Default

- `agentic/README.md`
- `agentic/state.example.yaml`
- `agentic/tasks.example.yaml`
- `agentic/agent-config.example.yaml`
- `agentic/prompts/BUILDER_ORGANIZER_PROMPT.txt`
- `agentic/workflows/WORKTREE_POLICY.md`
- `agentic/workflows/PORTING.md`
- `agentic/tasks/_template/TASK.md`
- `agentic/tasks/_template/handoffs/0001-example.md`

Optional:
- `agentic/planning/INITIATIVE_TEMPLATE.md`

## Do Not Copy By Default

- live `agentic/state.yaml`
- live `agentic/tasks.yaml`
- live `agentic/agent-config.yaml`
- any existing task instance under `agentic/tasks/`
- any live handoff history
- repo-specific runtime history

## Rules

- initialize fresh runtime state in the target repo
- do not overwrite existing tasks in the target repo
- do not overwrite existing live runtime files without an explicit decision
- treat the portable unit as workflow scaffolding, not active task history

## Agent Config Runtime Note

`agent-config.yaml` runtime handling is not finalized yet.

For now, initialize from `agentic/agent-config.example.yaml`.

Future repos or teams may choose:
- committed shared runtime config
- local runtime config
- shared base plus local override
