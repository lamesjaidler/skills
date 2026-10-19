#!/usr/bin/env bash
#
# Check transcript.sh against a fixture session. Run from anywhere:
#   bash docs/superpowers/tests/improve-workflow/transcript-test.sh
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$here/../../../.." && pwd)"
dir="$here/fixtures/transcript"

actual="$(bash "$root/product-development/skills/improve-workflow/transcript.sh" "$dir/session.jsonl")"
expected="$(sed "s|@DIR@|$dir|" "$dir/expected.txt")"

if diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual"); then
  echo PASS
else
  echo FAIL
  exit 1
fi
