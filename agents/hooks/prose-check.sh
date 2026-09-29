#!/usr/bin/env bash
# PostToolUse hook: lint the prose in edited files against the Communication
# Style rules, and feed any findings back to the model. Non-blocking.
#
# Shared by Claude Code and Codex. The two agents agree on the hook envelope
# (tool_name / tool_input / tool_response in, hookSpecificOutput out) but not on
# how an edit names its file: Claude's Write|Edit|MultiEdit carry
# tool_input.file_path, while Codex's apply_patch carries a patch blob that can
# touch several files at once. Handle both.
#
# The rules live in ../vale/, not here. Vale does the work because it parses
# source files with per-language tree-sitter grammars and lints only their
# comments, so a banned word in a doc comment is reported while the same word
# in an identifier or string literal is not. Its .vale.ini also decides which
# extensions are prose at all, which is why this script has no allowlist.
set -euo pipefail

input=$(cat)

# The config lives beside this script in the dotfiles repo. Resolve through the
# symlink that put us in ~/.claude/hooks or ~/.codex/hooks rather than guessing
# an install path, so both agents find the same rules.
self="$(readlink -f "${BASH_SOURCE[0]}")"
config="${VALE_CONFIG:-$(dirname "${self}")/../vale/.vale.ini}"

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

files=()
while IFS= read -r file; do
  [ -n "$file" ] || continue
  [ -f "$file" ] || continue

  # Skip binary files.
  grep -Iq . "$file" 2>/dev/null || continue

  files+=("$file")
done < <(
  {
    direct_paths
    patch_paths
  } | awk 'NF && !seen[$0]++'
)

[ ${#files[@]} -eq 0 ] && exit 0

# A style check that quietly stops running is worse than no style check, so say
# so instead of exiting clean.
report_skip() {
  jq -n --arg m "$1" '{systemMessage: ("Prose check skipped: " + $m)}'
  exit 0
}

# Hooks can be spawned from a shell with no mise activation, in which case the
# shims directory is not on PATH even though vale is installed. Same reason
# lefthook.yaml reaches for `mise exec` rather than trusting PATH.
if ! command -v vale >/dev/null 2>&1; then
  export PATH="${HOME}/.local/share/mise/shims:${PATH}"
fi

command -v vale >/dev/null 2>&1 || report_skip "vale is not on PATH. Install it with 'mise install vale'."
[ -f "$config" ] || report_skip "no Vale config at ${config}."

# --no-exit keeps this advisory: vale reports findings but returns 0, so a
# style nit never fails the tool call.
findings="$(vale --no-exit --output=line --config="$config" "${files[@]}" 2>/dev/null || true)"

[ -z "$findings" ] && exit 0

# vale emits file:line:col:Rule:Message. Regroup under each file so the model
# gets locations it can act on without re-reading the whole tree.
grouped="$(printf '%s\n' "$findings" | awk -F: '
  {
    file = $1
    rule = $4
    msg = $5
    for (i = 6; i <= NF; i++) msg = msg ":" $i
    if (file != last) { printf "%s:\n", file; last = file }
    printf "  line %s: %s (%s)\n", $2, msg, rule
  }
')"

msg="Style check: the prose below violates the Communication Style rules in your global instructions."

jq -n --arg m "$msg" --arg d "$grouped" '{
  systemMessage: ($m + "\n" + $d),
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: ($m + "\nLocations:\n" + $d + "\nFix these before continuing.")
  }
}'

exit 0
