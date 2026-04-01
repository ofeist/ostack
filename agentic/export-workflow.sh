#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: bash agentic/export-workflow.sh /path/to/target-repo" >&2
  exit 1
fi

TARGET="$1"
if [ ! -d "$TARGET" ]; then
  echo "Target repo does not exist: $TARGET" >&2
  exit 1
fi

copy_file() {
  local src="$1"
  local dst="$TARGET/$1"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "copied $1"
}

FILES=(
  "AGENTS.md"
  "docs/agentic-workflow.md"
  "agentic/PORTING.md"
  "agentic/tasks/TASK_TEMPLATE.md"
  "agentic/handoffs/HANDOFF_TEMPLATE.md"
  "agentic/handoffs/README.md"
  "agentic/planning/INITIATIVE_TEMPLATE.md"
  "agentic/workflows/WORKDIRS.md"
  "agentic/prompts/PLANNER_PROMPT.txt"
  "agentic/prompts/BUILDER_PROMPT.txt"
  "agentic/prompts/REVIEWER_PROMPT.txt"
  "agentic/prompts/QA_PROMPT.txt"
  "scripts/setup_agentic_worktrees.sh"
  "scripts/lint_changed.sh"
  "scripts/test_changed.sh"
)

for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    copy_file "$file"
  fi
done

echo "done"
