# Porting The Workflow

Port the workflow skeleton and templates only.

The portable unit is the committed scaffold, not another repo's live runtime state.

## Copy By Default

- `agentic/README.md`
- `agentic/state.example.yaml`
- `agentic/tasks.example.yaml`
- `agentic/agent-config.example.yaml`
- `agentic/prompts/BUILDER_ORGANIZER_PROMPT.txt`
- `agentic/workflows/WORKTREE_POLICY.md`
- `agentic/workflows/PORTING.md`
- `agentic/tasks/_template/TASK.md`
- `agentic/tasks/_template/handoffs/0001-builder-organizer-a-start.md`

Optional:
- `agentic/planning/INITIATIVE_TEMPLATE.md`

## Do Not Copy By Default

- live `agentic/state.yaml`
- live `agentic/tasks.yaml`
- live `agentic/agent-config.yaml`
- any existing task instance under `agentic/tasks/`
- any live handoff history
- repo-specific runtime history

## Runtime Lifecycle Policy

- `*.example.yaml` files are committed scaffold files and are the portable defaults for a fresh repo
- live `*.yaml` runtime files are committed shared state for the repo currently using the workflow
- live runtime files are authoritative inside that repo, but they are not portable defaults for a different repo
- when porting the workflow, copy the scaffold and initialize fresh live runtime files in the target repo
- when using a fresh clone of an already initialized repo, use the committed live runtime files from that repo rather than copying from `*.example.yaml` again

## Rules

- initialize fresh runtime state in the target repo
- do not overwrite existing tasks in the target repo
- do not overwrite existing live runtime files without an explicit decision
- treat the portable unit as workflow scaffolding, not active task history

## Initialization

- if the target repo has the scaffold but no live runtime files yet, run `bash agentic/bootstrap-runtime.sh`
- the bootstrap script copies each committed `*.example.yaml` file into its live runtime counterpart
- the bootstrap script refuses to overwrite existing live runtime files, so it is an initialization step, not a sync step
