# Handoff: <title>

Legacy reference template only.

For new workflow events, use task-local handoffs instead:
- `agentic/tasks/<task-id>/handoffs/NNNN-<actor-id>-<event>.md`

Prefer the active task-local templates under `agentic/tasks/_template/handoffs/`.

## Role
Builder / Reviewer / QA

## Branch
`<type>/<task-id>-<slug>` or `review/*` / `qa/*`

## Target commit
Which commit or branch tip was implemented, reviewed, or validated?

## Context
What task / slice is this about?

## Scope checked
What part of the slice did this handoff cover?

## Done
What was completed?

## Not done
What remains open?

## Artifacts changed
Which files / areas changed?

## Risks
What may break or needs follow-up?

## Verification
Which commands/tests/deploy checks were run?
What passed?
What was not run?

## Operational notes
Env, deploy, migration, webhook, staging/prod notes if relevant.

## Open questions / blockers
Only if relevant.

## Next
What should the next role do?
