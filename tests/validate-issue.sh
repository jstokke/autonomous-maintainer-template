#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$TMP_DIR/bin"
cat > "$TMP_DIR/bin/gh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "$1" == "issue" && "$2" == "view" ]]; then
  if [[ -z "${GH_FAKE_BODY:-}" ]]; then
    exit 1
  fi
  echo "${GH_FAKE_BODY}"
  exit 0
fi

if [[ "$1" == "issue" && "$2" == "edit" ]]; then
  echo "$*" >> "${GH_CALL_LOG:?}"
  exit 0
fi

echo "unexpected gh args: $*" >&2
exit 1
EOF
chmod +x "$TMP_DIR/bin/gh"

export PATH="$TMP_DIR/bin:$PATH"
export ISSUE_NUMBER=123
export GH_TOKEN=fake
export GH_CALL_LOG="$TMP_DIR/gh.log"

GH_FAKE_BODY=$'## Problem\nSimple problem\n\n## Acceptance Criteria\n- [ ] Done\n\n## Constraints\nNo new APIs\n\n## Impact\nDX\n\n## Estimated Effort\nS\n\n## Execution Owner\nAutonomous Maintainer\n'
export GH_FAKE_BODY

: > "$GH_CALL_LOG"
if ! "$ROOT_DIR/scripts/validate-issue.sh"; then
  echo "Expected success but got failure" >&2
  exit 1
fi
if [[ -s "$GH_CALL_LOG" ]]; then
  echo "Unexpected label edit on success" >&2
  exit 1
fi

GH_FAKE_BODY=$'## Problem\nMissing constraints\n\n## Acceptance Criteria\n- [ ] Done\n\n## Impact\nDX\n\n## Estimated Effort\nS\n\n## Execution Owner\nAutonomous Maintainer\n'
export GH_FAKE_BODY

: > "$GH_CALL_LOG"
if "$ROOT_DIR/scripts/validate-issue.sh"; then
  echo "Expected failure for missing sections" >&2
  exit 1
fi
grep -q "needs-human" "$GH_CALL_LOG"