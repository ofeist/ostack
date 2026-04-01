# Handoffs

Use one directory per task and one file per role.

Recommended shape:
- `agentic/handoffs/TASK-XXXX-<task-slug>/builder.md`
- `agentic/handoffs/TASK-XXXX-<task-slug>/review.md`
- `agentic/handoffs/TASK-XXXX-<task-slug>/qa.md`
- optional: `agentic/handoffs/TASK-XXXX-<task-slug>/owner.md`

Why:
- avoids merge conflicts between roles
- gives Builder, Reviewer, QA, and Owner a shared written channel
- removes the need to copy/paste findings between workdirs

Rules:
- Builder writes `builder.md`
- Reviewer writes `review.md`
- QA writes `qa.md`
- Owner records final decisions or rejected findings in `owner.md` when needed
- prefer updating these files over creating ad hoc scratch notes elsewhere
