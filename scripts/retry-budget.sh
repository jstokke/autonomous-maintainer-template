#!/usr/bin/env bash
set -euo pipefail

: "${PR_NUMBER:?PR_NUMBER is required}"
: "${ISSUE_NUMBER:?ISSUE_NUMBER is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"

MAX_RETRIES="${MAX_RETRIES:-2}"
CURRENT_RETRIES="$(gh pr view "$PR_NUMBER" --json comments -q '.comments | length')"

if ! [[ "$CURRENT_RETRIES" =~ ^[0-9]+$ ]]; then
  echo "Could not determine retry count."
  exit 1
fi

if [ "$CURRENT_RETRIES" -gt "$MAX_RETRIES" ]; then
  gh issue edit "$ISSUE_NUMBER" --add-label needs-human
  exit 1
fi
