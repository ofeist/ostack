# Handoffs

This directory is legacy reference material.

Do not use `agentic/handoffs/` for new workflow events.

Current handoffs are task-local:
- `agentic/tasks/<task-id>/handoffs/NNNN-<actor-id>-<event>.md`

Examples:
- `agentic/tasks/TASK-0001/handoffs/0001-builder-organizer-a-start.md`
- `agentic/tasks/TASK-0001/handoffs/0002-builder-organizer-a-complete.md`
- `agentic/tasks/TASK-0001/handoffs/0003-reviewer-1-approve.md`

Why:
- avoids merge conflicts between roles
- gives Builder, Reviewer, QA, and Owner a shared written channel
- removes the need to copy/paste findings between workdirs

Rules:
- one handoff event is one new numbered file
- write handoffs under the relevant task folder only
- do not rewrite prior handoff history except for minor typo fixes
