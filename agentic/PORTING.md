# Porting The Agentic Workflow

This repo keeps the reusable workflow under `agentic/` plus a small set of top-level docs and helper scripts.

## Minimum portable subset

Copy these files into the target repo:

- `AGENTS.md`
- `docs/agentic-workflow.md`
- `agentic/tasks/TASK_TEMPLATE.md`
- `agentic/handoffs/HANDOFF_TEMPLATE.md`
- `agentic/handoffs/README.md`
- `agentic/planning/INITIATIVE_TEMPLATE.md`
- `agentic/workflows/WORKDIRS.md`
- `agentic/prompts/PLANNER_PROMPT.txt`
- `agentic/prompts/BUILDER_PROMPT.txt`
- `agentic/prompts/REVIEWER_PROMPT.txt`
- `agentic/prompts/QA_PROMPT.txt`

## Optional helpers

Copy these if the target repo benefits from them:

- `scripts/setup_agentic_worktrees.sh`
- `scripts/lint_changed.sh`
- `scripts/test_changed.sh`

## Usually not portable as-is

These are repo-specific and should be rewritten or skipped:

- `ops/versioning-policy.md`
- `docs/agentic_codex_3_workdir_skeleton.md`
- any real task instance under `agentic/tasks/` such as `TASK-0001-...`

## Fastest way

Run:

```bash
bash agentic/export-workflow.sh /path/to/target-repo
```

That copies the reusable subset into the target repo and skips repo-specific task instances.

## After copying

1. Read `AGENTS.md` and make repo-specific edits.
2. Read `docs/agentic-workflow.md` and trim anything the target repo does not need.
3. Decide whether the target repo needs worktrees or can start with one workdir.
4. Adjust `scripts/lint_changed.sh` and `scripts/test_changed.sh` to the target repo's real checks.
5. If the target repo has release/versioning rules, add or replace any repo-specific policy docs.
