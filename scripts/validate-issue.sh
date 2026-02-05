#!/usr/bin/env bash
set -euo pipefail

: "${ISSUE_NUMBER:?ISSUE_NUMBER is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"

BODY="$(gh issue view "$ISSUE_NUMBER" --json body -q .body)"

required_sections=(
  "## Problem"
  "## Acceptance Criteria"
  "## Constraints"
  "## Impact"
  "## Estimated Effort"
  "## Execution Owner"
)

missing=()
for section in "${required_sections[@]}"; do
  if ! grep -q "$section" <<< "$BODY"; then
    missing+=("$section")
  fi
done

if (( ${#missing[@]} > 0 )); then
  echo "Missing section(s):"
  printf ' - %s\n' "${missing[@]}"
  gh issue edit "$ISSUE_NUMBER" --add-label needs-human
  exit 1
fi
