#!/usr/bin/env bash
# Load a plugin live from this repo into a throwaway Claude Code session.
# No install, no cache: edits to SKILL.md are picked up on each relaunch.
# This is the fast iterate loop — use it instead of reinstalling per edit.
#
# Usage: scripts/dev.sh <plugin>     e.g. scripts/dev.sh product-critique
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

list_plugins() {
  for m in "$root"/*/.claude-plugin/plugin.json; do
    [ -f "$m" ] && echo "  - $(basename "$(dirname "$(dirname "$m")")")"
  done
}

plugin="${1:-}"
if [ -z "$plugin" ]; then
  echo "usage: scripts/dev.sh <plugin>" >&2
  echo "plugins:" >&2
  list_plugins >&2
  exit 1
fi

dir="$root/$plugin"
if [ ! -f "$dir/.claude-plugin/plugin.json" ]; then
  echo "no plugin manifest at $dir/.claude-plugin/plugin.json" >&2
  echo "plugins:" >&2
  list_plugins >&2
  exit 1
fi

echo "Loading '$plugin' live from $dir (session-only, no install)…" >&2
exec claude --plugin-dir "$dir"
