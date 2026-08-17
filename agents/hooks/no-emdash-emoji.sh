#!/usr/bin/env bash
# PostToolUse hook: warn when an edited file contains em-dashes or emojis,
# enforcing the Hard Rules in the Communication Style section of the global
# instructions. Non-blocking: it surfaces a warning and feeds the locations back
# to the model so they can be fixed.
#
# Shared by Claude Code and Codex. The two agents agree on the hook envelope
# (tool_name / tool_input / tool_response in, hookSpecificOutput out) but not on
# how an edit names its file: Claude's Write|Edit|MultiEdit carry
# tool_input.file_path, while Codex's apply_patch carries a patch blob that can
# touch several files at once. Handle both.
set -euo pipefail

input=$(cat)

# Paths named directly by the tool call (Claude Code).
direct_paths() {
  printf '%s' "$input" | jq -r '
    [.tool_input.file_path?, .tool_response.filePath?]
    | map(select(type == "string" and . != ""))
    | .[]
  ' 2>/dev/null || true
}

# Paths named inside an apply_patch envelope (Codex). The patch arrives either
# as an argv array or as a freeform string depending on apply_patch_tool_type.
patch_paths() {
  printf '%s' "$input" | jq -r '
    [ (.tool_input.command? | if type == "array" then .[] else empty end),
      .tool_input.input?,
      .tool_input.patch?
    ]
    | map(select(type == "string"))
    | join("\n")
  ' 2>/dev/null |
    grep -E '^\*\*\* (Update|Add|Move to) File: ' |
    sed -E 's/^\*\*\* (Update|Add|Move to) File: //' || true
}

findings=""
while IFS= read -r file; do
  [ -n "$file" ] || continue
  [ -f "$file" ] || continue

  # Skip binary files.
  grep -Iq . "$file" 2>/dev/null || continue

  hits=$(perl -CSD -ne '
    while (/([\x{2014}])|([\x{1F300}-\x{1FAFF}\x{1F000}-\x{1F0FF}\x{2600}-\x{27BF}\x{2B00}-\x{2BFF}\x{1F1E6}-\x{1F1FF}\x{FE0F}])/g) {
      my $what = defined($1) ? "em-dash" : "emoji";
      print "  line $.: $what\n";
      last;
    }
  ' "$file" 2>/dev/null || true)

  [ -n "$hits" ] || continue
  # NB: the trailing newline matters, $(...) strips it off $hits.
  findings="${findings}${file}:
${hits}
"
done < <(
  {
    direct_paths
    patch_paths
  } | awk 'NF && !seen[$0]++'
)

[ -z "$findings" ] && exit 0

msg="Style check: the following files contain em-dashes or emojis, which violate the Hard Rules in the Communication Style section of your global instructions. Replace em-dashes with commas, semicolons, or a regular dash (-); remove emojis."

jq -n --arg m "$msg" --arg d "$findings" '{
  systemMessage: ($m + "\n" + $d),
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: ($m + "\nLocations:\n" + $d + "\nFix these before continuing.")
  }
}'

exit 0
