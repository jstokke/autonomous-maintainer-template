#!/usr/bin/env bash
set -e

echo "Checking invariants..."

# Example guardrails (extend as needed)
# Check for added 'public' access modifiers in source code
# Uses --unified=0 to exclude context lines, and greps for lines starting with + that contain "public "
if git diff origin/main...HEAD --unified=0 | grep -E "^\+.*[[:space:]]public[[:space:]]"; then
  echo "Invariant violation: public API change detected"
  exit 1
fi

echo "Invariants OK"
