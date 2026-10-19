#!/usr/bin/env bash
#
# Print a Claude Code session transcript (.jsonl) as readable text: one entry per
# message, tool inputs and results cut to 500 chars, thinking and meta entries
# dropped. Ends with a list of the session's subagent transcripts, if any.
#
# Usage: bash transcript.sh <transcript.jsonl>
# Requires: jq
set -euo pipefail

[ $# -eq 1 ] || { echo "usage: bash transcript.sh <transcript.jsonl>" >&2; exit 2; }
file="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"

jq -r '
  def cut: if length > 500 then .[0:500] + " …[+\(length - 500) chars]" else . end;
  select((.type == "user" or .type == "assistant") and .isMeta != true)
  | .type as $role
  | .message.content
  | if type == "string" then "[\($role)] \(.)"
    else .[]
      | if .type == "text" then "[\($role)] \(.text)"
        elif .type == "tool_use" then "[tool_use \(.name)] \(.input | tojson | cut)"
        elif .type == "tool_result" then
          "[tool_result] \(if (.content | type) == "string" then .content
                           else [.content[]? | select(.type == "text") | .text] | join("\n") end
                           | cut)"
        else empty end
    end
' "$file"

sub="${file%.jsonl}/subagents"
if [ -d "$sub" ]; then
  echo "[subagents]"
  for t in "$sub"/agent-*.jsonl; do
    [ -e "$t" ] || continue
    meta="${t%.jsonl}.meta.json"
    desc=""
    [ -f "$meta" ] && desc="$(jq -r '.description // ""' "$meta")"
    printf '%s\t%s\n' "$t" "$desc"
  done
fi
