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

if [[ "$1" == "pr" && "$2" == "view" ]]; then
  echo "${GH_FAKE_COMMENTS:-0}"
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
export PR_NUMBER=55
export ISSUE_NUMBER=77
export GH_TOKEN=fake
export GH_CALL_LOG="$TMP_DIR/gh.log"

GH_FAKE_COMMENTS=1
export GH_FAKE_COMMENTS

: > "$GH_CALL_LOG"
if ! "$ROOT_DIR/scripts/retry-budget.sh"; then
  echo "Expected success but got failure" >&2
  exit 1
fi
if [[ -s "$GH_CALL_LOG" ]]; then
  echo "Unexpected label edit on success" >&2
  exit 1
fi

GH_FAKE_COMMENTS=3
export GH_FAKE_COMMENTS

: > "$GH_CALL_LOG"
if "$ROOT_DIR/scripts/retry-budget.sh"; then
  echo "Expected failure for exceeded retries" >&2
  exit 1
fi
grep -q "needs-human" "$GH_CALL_LOG"