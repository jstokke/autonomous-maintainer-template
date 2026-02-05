#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${BASE_REF:-}"
if [[ -z "$BASE_REF" ]]; then
  if [[ -n "${GITHUB_BASE_REF:-}" ]]; then
    BASE_REF="origin/${GITHUB_BASE_REF}"
  else
    BASE_REF="origin/main"
  fi
fi

if ! git rev-parse --verify "$BASE_REF" >/dev/null 2>&1; then
  echo "Base ref '$BASE_REF' not found. Set BASE_REF or fetch the base branch."
  exit 2
fi

echo "Checking invariants against $BASE_REF..."

# Example guardrails (extend as needed)
# Check for added 'public' access modifiers in source code
# Uses --unified=0 to exclude context lines, and greps for lines starting with + that contain "public "
if git diff "$BASE_REF"...HEAD --unified=0 | grep -E "^\+.*[[:space:]]public[[:space:]]"; then
  echo "Invariant violation: public API change detected"
  exit 1
fi

echo "Invariants OK"
