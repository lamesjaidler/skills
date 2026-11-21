#!/usr/bin/env bash
# Mechanical checks on PRDs written by create-raw-prd test runs.
# Usage: bash check.sh <prd.md>...
# Prints one line per file. "page" is the text above the appendix (its "---" line and
# "## Appendix" heading), or the whole file when there is none; "total" is the whole file.
# The fact-retention checks in scenarios.md are graded by reading the file.
set -euo pipefail

sections=("## Problem" "## Users" "## Goals & success metrics" "## Non-goals"
  "## Requirements" "## Assumptions & open questions" "## Risks")

for f in "$@"; do
  total=$(wc -w <"$f" | tr -d ' ')
  page=$(awk '/^---$/ || /^## Appendix/ { exit } { print }' "$f" | wc -w | tr -d ' ')
  r=$(grep -cE '^R[0-9]+\.' "$f" || true)
  a=$(grep -cE '^A[0-9]+\.' "$f" || true)
  q=$(grep -cE '^Q[0-9]+\.' "$f" || true)
  missing=""
  for s in "${sections[@]}"; do
    grep -qxF "$s" "$f" || missing="$missing [$s]"
  done
  grep -qE '^Status: (raw draft, not yet critiqued|critiqued) · ' "$f" || missing="$missing [Status line]"
  echo "$f: page=$page total=$total R=$r A=$a Q=$q missing=${missing:-none}"
done
