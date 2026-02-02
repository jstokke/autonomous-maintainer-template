#!/usr/bin/env bash
MAX_RETRIES=2
CURRENT_RETRIES=$(gh pr view "$PR_NUMBER" --json comments -q '.comments | length')

if [ "$CURRENT_RETRIES" -gt "$MAX_RETRIES" ]; then
  gh issue edit "$ISSUE_NUMBER" --add-label needs-human
  exit 1
fi
