#!/usr/bin/env bash
#
# Validate the marketplace manifest and every in-repo plugin it references.
# Run locally before pushing; also runs in CI (.github/workflows/validate.yml).
#
# Requires: jq
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MARKET=".claude-plugin/marketplace.json"
fail=0
err() { echo "  ✗ $1"; fail=1; }
ok()  { echo "  ✓ $1"; }

command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed"; exit 2; }

echo "Validating $MARKET"
[ -f "$MARKET" ] || { echo "  ✗ $MARKET not found"; exit 1; }
jq empty "$MARKET" 2>/dev/null || { echo "  ✗ $MARKET is not valid JSON"; exit 1; }
ok "valid JSON"

[ -n "$(jq -r '.name // empty' "$MARKET")" ]       || err "marketplace .name missing"
[ -n "$(jq -r '.owner.name // empty' "$MARKET")" ] || err "marketplace .owner.name missing"
jq -e '.plugins | type == "array"' "$MARKET" >/dev/null 2>&1 || { err ".plugins must be an array"; }

count=$(jq '.plugins | length' "$MARKET")
echo "Found $count plugin(s)"

for i in $(seq 0 $((count - 1))); do
  name=$(jq -r ".plugins[$i].name // empty" "$MARKET")
  src=$(jq -r ".plugins[$i].source // empty" "$MARKET")
  echo "Plugin: ${name:-<unnamed>} (source: ${src:-<none>})"

  [ -n "$name" ] || { err "plugins[$i] has no name"; continue; }
  [ -n "$src" ]  || { err "$name has no source"; continue; }

  # Only local string sources ("./dir") are validated structurally here.
  case "$src" in
    ./*)
      dir="${src#./}"
      [ -d "$dir" ] || { err "$name: source dir '$dir' not found"; continue; }

      pj="$dir/.claude-plugin/plugin.json"
      [ -f "$pj" ] || { err "$name: missing $pj"; continue; }
      jq empty "$pj" 2>/dev/null || { err "$name: $pj is not valid JSON"; continue; }

      pjname=$(jq -r '.name // empty' "$pj")
      [ "$pjname" = "$name" ] || err "$name: plugin.json name '$pjname' != marketplace name '$name'"

      if find "$dir/skills" -name SKILL.md 2>/dev/null | grep -q .; then
        # Each SKILL.md dir name should match its frontmatter `name:`.
        while IFS= read -r skill; do
          sdir=$(basename "$(dirname "$skill")")
          fmname=$(awk '/^name:/ {print $2; exit}' "$skill")
          [ "$sdir" = "$fmname" ] || err "$name: skill dir '$sdir' != SKILL.md name '$fmname'"
        done < <(find "$dir/skills" -name SKILL.md)
        ok "$name: skill(s) present and named consistently"
      else
        err "$name: no skills/*/SKILL.md found"
      fi
      ;;
    *)
      ok "$name: non-local source, structural check skipped"
      ;;
  esac
done

echo
if [ "$fail" -ne 0 ]; then
  echo "VALIDATION FAILED"
  exit 1
fi
echo "All checks passed."
