#!/usr/bin/env bash
# Promote a finished change to the installed (daily-driver) copy of a plugin.
#
# The plugin cache is VERSION-KEYED: `claude plugin update` re-copies only when
# plugin.json's version is higher than what's installed. An unchanged version
# no-ops and the cache stays stale — there is no --force. So a release is always
# a version bump, which this script performs before refreshing the install.
#
# Usage: scripts/release.sh <plugin> <new-version>
#        e.g. scripts/release.sh product-critique 0.0.1
set -euo pipefail

plugin="${1:?usage: scripts/release.sh <plugin> <new-version>}"
version="${2:?usage: scripts/release.sh <plugin> <new-version>}"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$root/$plugin/.claude-plugin/plugin.json"
[ -f "$manifest" ] || { echo "no manifest at $manifest" >&2; exit 1; }

# Validate manifests + skill naming before touching anything.
bash "$root/scripts/validate-marketplace.sh"

# Bump the single "version" key in plugin.json (portable; avoids sed -i differences).
tmp="$(mktemp)"
sed "s/\"version\": *\"[^\"]*\"/\"version\": \"$version\"/" "$manifest" >"$tmp" && mv "$tmp" "$manifest"
echo "Set $plugin version -> $version"

# Refresh the installed copy from the local 'skills' marketplace (the repo dir).
claude plugin marketplace update skills
claude plugin update "$plugin@skills"

cat >&2 <<EOF

Done. Next:
  - Restart Claude Code to load the new version.
  - Add a CHANGELOG.md line under '$plugin'.
  - Commit the version bump and open a PR to main.
EOF
