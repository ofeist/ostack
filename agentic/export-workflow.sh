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

REQUIRED_FILES=(
  "agentic/README.md"
  "agentic/PORTING.md"
  "agentic/bootstrap-runtime.sh"
  "agentic/state.example.yaml"
  "agentic/tasks.example.yaml"
  "agentic/agent-config.example.yaml"
  "agentic/prompts/BUILDER_ORGANIZER_PROMPT.txt"
  "agentic/prompts/REVIEWER_PROMPT.txt"
  "agentic/prompts/QA_PROMPT.txt"
  "agentic/prompts/init-builder-organizer.md"
  "agentic/prompts/init-reviewer.md"
  "agentic/prompts/init-qa.md"
  "agentic/workflows/WORKTREE_POLICY.md"
  "agentic/workflows/PORTING.md"
  "agentic/tasks/_template/TASK.md"
  "agentic/tasks/_template/handoffs/0001-builder-organizer-a-start.md"
)

OPTIONAL_FILES=(
  "agentic/planning/INITIATIVE_TEMPLATE.md"
)

missing=()
for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$file" ]; then
    copy_file "$file"
  else
    missing+=("$file")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing required scaffold files:" >&2
  printf ' - %s\n' "${missing[@]}" >&2
  exit 1
fi

for file in "${OPTIONAL_FILES[@]}"; do
  if [ -f "$file" ]; then
    copy_file "$file"
  fi
done

echo "runtime files were not copied; run 'bash agentic/bootstrap-runtime.sh' in the target repo if fresh runtime initialization is needed"
echo "done"
