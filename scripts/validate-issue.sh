#!/usr/bin/env bash
set -e

BODY="$(gh issue view "$ISSUE_NUMBER" --json body -q .body)"

required_sections=(
  "## Problem"
  "## Acceptance Criteria"
  "## Constraints"
  "## Impact"
  "## Estimated Effort"
)

for section in "${required_sections[@]}"; do
  if ! grep -q "$section" <<< "$BODY"; then
    echo "Missing section: $section"
    gh issue edit "$ISSUE_NUMBER" --add-label needs-human
    exit 1
  fi
done
