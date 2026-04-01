# Handoff: <title>

Copy this into a role-specific file under a per-task directory, for example:
- `agentic/handoffs/TASK-0001-cut-release-workflow/builder.md`
- `agentic/handoffs/TASK-0001-cut-release-workflow/review.md`
- `agentic/handoffs/TASK-0001-cut-release-workflow/qa.md`

Use one file per role to avoid merge conflicts.

## Role
Builder / Reviewer / QA

## Branch
`feature/<task-slug>` or `review/*` / `qa/*`

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
