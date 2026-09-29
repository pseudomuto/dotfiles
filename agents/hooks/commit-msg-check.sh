#!/usr/bin/env bash
# PreToolUse hook: lint a commit message against the Communication Style rules
# before the commit happens.
#
# Commit messages are the one prose surface prose-check.sh cannot see. It hooks
# Write|Edit|MultiEdit, but a commit is a Bash call, so the message never
# touches a file the editor tools report.
#
# This denies rather than warns, which is the deliberate exception to the
# otherwise advisory style checking. A PostToolUse warning would arrive after
# the commit already exists, and the only remedy then is amending history. The
# commit has not happened yet here, so the model just rewrites and retries.
#
# Claude only. Codex's shell tool is not wired, so commits it makes are
# unchecked. The matcher name would need confirming against a Codex transcript
# first.
set -euo pipefail

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""' 2>/dev/null || true)

# Only interested in commits that carry a message inline. Match `commit` as
# git's subcommand, allowing -C/-c pairs in between, not just anywhere after
# "git". A loose *git*commit* glob fires on `git add commit-msg-check.sh`, and
# any heredoc in that command then gets linted as though it were the message.
git_commit='(^|[;&|(`[:space:]])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)'
printf '%s' "$command" | grep -Eq "$git_commit" || exit 0

# Two forms the git-commit skill produces:
#
#   git commit -m "$(cat <<'EOF' ... EOF)"    multi-line, the common case
#   git commit -m "subject"                   single line
#
# Anything else, including -F and -C, is left alone. Failing to extract means
# not checking; it must never mean blocking a commit on a misparse.
msg=""
if printf '%s' "$command" | grep -q "<<'\?EOF'\?"; then
  msg=$(printf '%s' "$command" | awk "/<<'?EOF'?/{flag=1;next} /^EOF\$/{flag=0} flag")
else
  msg=$(printf '%s' "$command" |
    sed -n "s/.*-m[[:space:]]*\"\([^\"]*\)\".*/\1/p;s/.*-m[[:space:]]*'\([^']*\)'.*/\1/p" |
    head -1)
fi

[ -n "$msg" ] || exit 0

self="$(readlink -f "${BASH_SOURCE[0]}")"
config="${VALE_CONFIG:-$(dirname "${self}")/../vale/.vale.ini}"

if ! command -v vale >/dev/null 2>&1; then
  export PATH="${HOME}/.local/share/mise/shims:${PATH}"
fi
command -v vale >/dev/null 2>&1 || exit 0
[ -f "$config" ] || exit 0

# vale reads nothing from stdin, it silently lints zero bytes and exits 0, so
# the message has to reach it as a file. The .md extension is what matches the
# format section in .vale.ini.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
printf '%s\n' "$msg" > "$tmp/COMMIT_MSG.md"

findings=$(vale --no-exit --output=line --config="$config" "$tmp/COMMIT_MSG.md" 2>/dev/null || true)
[ -z "$findings" ] && exit 0

# Strip the temp path; the model needs the rule and the line, not a tempdir.
detail=$(printf '%s\n' "$findings" | awk -F: '
  {
    rule = $4
    msg = $5
    for (i = 6; i <= NF; i++) msg = msg ":" $i
    printf "  line %s: %s (%s)\n", $2, msg, rule
  }
')

reason="This commit message violates the Communication Style rules in your global instructions:
${detail}
Rewrite the message and commit again."

jq -n --arg r "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $r
  }
}'

exit 0
