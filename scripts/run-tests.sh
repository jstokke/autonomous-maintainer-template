#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$ROOT_DIR/tests"

if [[ ! -d "$TEST_DIR" ]]; then
  echo "No tests directory found."
  exit 0
fi

shopt -s nullglob
test_files=("$TEST_DIR"/*.sh)

if (( ${#test_files[@]} == 0 )); then
  echo "No tests found."
  exit 0
fi

fail=0
for test_file in "${test_files[@]}"; do
  echo "Running $(basename "$test_file")"
  if ! bash "$test_file"; then
    echo "FAILED: $(basename "$test_file")"
    fail=1
  fi
done

exit "$fail"