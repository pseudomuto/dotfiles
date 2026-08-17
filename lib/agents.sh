# Coding agent (Claude Code, Codex) configuration.
#
# Instructions are assembled from shared fragments in agents/base plus an
# optional per-agent tail, rendered into .build, and symlinked into place. Local
# skills are shared by both agents. External plugins are owned by each agent's
# own plugin manager: Claude via settings.json, Codex via `codex plugin`.
#
# agents/rules holds topic rules authored once and rendered per agent. See
# render_rules for why the two agents get different artifacts.
#
# Expects lib/utils.sh to be sourced first and the cwd to be the repo root.

AGENTS_DIR="agents"
BUILD_DIR=".build"
CLAUDE_HOME="${HOME}/.claude"
CODEX_HOME="${HOME}/.codex"

# Namespace for skills generated from agents/rules, keeping them clear of the
# hand-written skills they share a directory with.
RULE_SKILL_PREFIX="rule-"

setup_agents() {
  # Build first, then prune, so links to artifacts that no longer exist are
  # dangling by the time the sweep runs.
  render_rules

  render_instructions "${BUILD_DIR}/claude/CLAUDE.md" \
    "${AGENTS_DIR}"/base/*.md "${AGENTS_DIR}/claude/instructions.md"
  render_instructions "${BUILD_DIR}/codex/AGENTS.md" \
    "${AGENTS_DIR}"/base/*.md "${BUILD_DIR}"/codex/fragments/*.md \
    "${AGENTS_DIR}/codex/instructions.md"

  prune_dotfiles_links "${CLAUDE_HOME}"
  prune_dotfiles_links "${CODEX_HOME}"

  link_rules
  link_file "${BUILD_DIR}/claude/CLAUDE.md" "${CLAUDE_HOME}/CLAUDE.md"
  link_file "${BUILD_DIR}/codex/AGENTS.md" "${CODEX_HOME}/AGENTS.md"
  link_file "${AGENTS_DIR}/claude/settings.json" "${CLAUDE_HOME}/settings.json"

  # NB: agents/claude is not linked wholesale. instructions.md is an input to
  # the render above, not something Claude should read on its own.
  # Hook scripts are shared. Both agents send the same envelope (tool_name,
  # tool_input, tool_response) and read the same hookSpecificOutput back, so one
  # script serves both. Only the wiring that points at them is per agent.
  link_directory_recursively "${AGENTS_DIR}/hooks" "${CLAUDE_HOME}/hooks"
  link_directory_recursively "${AGENTS_DIR}/hooks" "${CODEX_HOME}/hooks"

  # Claude wires hooks in settings.json. Codex reads a sidecar hooks.json, which
  # is a whole file we can own; its config.toml is off limits because Codex
  # writes project trust and hook trust state into it.
  link_file "${AGENTS_DIR}/codex/hooks.json" "${CODEX_HOME}/hooks.json"

  local dir
  for dir in commands agents; do
    if [[ -d "${AGENTS_DIR}/claude/${dir}" ]]; then
      link_directory_recursively "${AGENTS_DIR}/claude/${dir}" "${CLAUDE_HOME}/${dir}"
    fi
  done

  link_skills "${AGENTS_DIR}/skills" "${CLAUDE_HOME}/skills"
  link_skills "${AGENTS_DIR}/skills" "${CODEX_HOME}/skills"

  sync_claude_plugins "${AGENTS_DIR}/claude/settings.json"
  sync_codex_plugins "${AGENTS_DIR}/codex/plugins.tsv"
}

# settings.json declares marketplaces and which plugins should be enabled, but
# enabledPlugins only enables an already-installed plugin. Nothing in it makes
# Claude install one, so a fresh machine would come up with five enabled plugins
# and none of them present. Reconcile that here.
sync_claude_plugins() {
  local settings="${1}"

  if ! command -v claude >/dev/null 2>&1; then
    gum log --level warn "claude not found, skipping its plugins"
    return 0
  fi

  [[ -f "${settings}" ]] || return 0

  local installed plugin
  # Pull plugin@marketplace ids out of the listing rather than parsing its
  # layout, which is decorated and version dependent.
  installed="$(claude plugin list 2>/dev/null |
    grep -oE '[A-Za-z0-9_.-]+@[A-Za-z0-9_.-]+' || true)"

  while IFS= read -r plugin; do
    [[ -n "${plugin}" ]] || continue

    if ! grep -qxF "${plugin}" <<<"${installed}"; then
      gum log --level info "Installing claude plugin ${plugin}"
      claude plugin install "${plugin}" --yes
    fi
  done < <(jq -r '.enabledPlugins // {} | to_entries[] | select(.value) | .key' "${settings}")
}

# One rule, two renderings, because the agents don't offer the same mechanism.
#
# A rule is markdown with frontmatter: an optional `paths` list of globs, and a
# `description` used when the rule has to be surfaced as a skill.
#
#   with paths     scoped guidance, e.g. "when writing Go, do X"
#     Claude   ->  ~/.claude/rules/<name>.md keeping `paths`, so it loads
#                  whenever Claude reads a matching file
#     Codex    ->  a skill named rule-<name>, because Codex has no glob-scoped
#                  instruction file at all; its rules/ dir is exec policy and
#                  its AGENTS.md nesting is directory-scoped. Model-invoked is
#                  the closest it gets.
#
#   without paths  always-on guidance, e.g. communication style
#     Claude   ->  ~/.claude/rules/<name>.md with no frontmatter, loaded every
#                  session at the same priority as CLAUDE.md
#     Codex    ->  concatenated into AGENTS.md, its only unconditional channel
render_rules() {
  local claude_out="${BUILD_DIR}/claude/rules"
  local skills_out="${BUILD_DIR}/codex/skills"
  local frags_out="${BUILD_DIR}/codex/fragments"

  rm -rf "${claude_out}" "${skills_out}" "${frags_out}"
  mkdir -p "${claude_out}" "${skills_out}" "${frags_out}"

  [[ -d "${AGENTS_DIR}/rules" ]] || return 0

  local rule name paths description
  for rule in "${AGENTS_DIR}"/rules/*.md; do
    [[ -f "${rule}" ]] || continue

    name="$(basename "${rule}" .md)"
    paths=""
    description=""

    # yq --front-matter=extract parses the whole file as YAML when there is no
    # frontmatter to extract, which blows up on ordinary prose. Only ask if the
    # file actually opens with a frontmatter block.
    if [[ "$(head -1 "${rule}")" == "---" ]]; then
      paths="$(yq --front-matter=extract '.paths // ""' "${rule}")"
      description="$(yq --front-matter=extract '.description // ""' "${rule}")"
    fi

    gum log --level info "Rendering rule ${name}"

    if [[ -n "${paths}" ]]; then
      # Claude keeps the globs. Emit only `paths`; our `description` is an
      # input to the Codex side and not part of Claude's schema.
      {
        echo "---"
        yq --front-matter=extract '{"paths": .paths}' "${rule}"
        echo "---"
        echo
        rule_body "${rule}"
      } >"${claude_out}/${name}.md"

      # Generated skills share ~/.codex/skills with the hand-written ones in
      # agents/skills, so namespace them. A rule named `go` becomes
      # rule-go, leaving `go` free for a real skill.
      local skill="${RULE_SKILL_PREFIX}${name}"

      if [[ -d "${AGENTS_DIR}/skills/${skill}" ]]; then
        gum log --level error \
          "Rule ${name} renders to skill ${skill}, which collides with agents/skills/${skill}. Rename one of them."
        exit 1
      fi

      mkdir -p "${skills_out}/${skill}"
      {
        echo "---"
        skill="${skill}" description="${description}" \
          yq -n '{"name": strenv(skill), "description": strenv(description)}'
        echo "---"
        echo
        rule_body "${rule}"
      } >"${skills_out}/${skill}/SKILL.md"
    else
      rule_body "${rule}" >"${claude_out}/${name}.md"
      rule_body "${rule}" >"${frags_out}/${name}.md"
    fi
  done
}

# Everything after the YAML frontmatter, or the whole file if it has none.
rule_body() {
  awk '
    NR == 1 && /^---$/ { fm = 1; next }
    fm == 1 && /^---$/ { fm = 2; next }
    fm == 1 { next }
    # Swallow blank lines until the body actually starts, so callers can always
    # put exactly one blank line after the frontmatter they emit.
    !started && /^[[:space:]]*$/ { next }
    { started = 1; print }
  ' "${1}"
}

link_rules() {
  link_directory_recursively "${BUILD_DIR}/claude/rules" "${CLAUDE_HOME}/rules"
  link_skills "${BUILD_DIR}/codex/skills" "${CODEX_HOME}/skills"
}

# Concatenate fragments into a single generated instructions file. Fragments
# that don't exist are skipped, so the per-agent tails are optional.
render_instructions() {
  local out="${1}"
  shift

  gum log --level info "Rendering ${out}"
  mkdir -p "$(dirname "${out}")"

  {
    echo "<!-- Generated by dotfiles/apply. Do not edit."
    echo "     Edit agents/base/*.md or agents/<agent>/instructions.md instead. -->"
    echo
  } >"${out}"

  local fragment
  for fragment in "$@"; do
    if [[ -f "${fragment}" ]]; then
      cat "${fragment}" >>"${out}"
      echo >>"${out}"
    fi
  done
}

link_file() {
  local src="${1}"
  local dest="${2}"

  gum log --level info "Linking ${dest}"
  mkdir -p "$(dirname "${dest}")"

  if ! ln -sfn "$(pwd)/${src}" "${dest}"; then
    gum log --level error "Failed linking ${dest}"
    exit 1
  fi
}

# Skills are linked as directories, not per-file. A skill is a unit and several
# of them ship supporting docs alongside SKILL.md.
link_skills() {
  local src_dir="${1}"
  local dest_dir="${2}"

  mkdir -p "${dest_dir}"

  local skill
  for skill in "${src_dir}"/*/; do
    [[ -d "${skill}" ]] || continue
    link_file "${skill%/}" "${dest_dir}/$(basename "${skill}")"
  done
}

# Tab separated: marketplace source, then plugin@marketplace. Both steps are
# guarded so re-running apply is a no-op.
sync_codex_plugins() {
  local file="${1}"

  if ! command -v codex >/dev/null 2>&1; then
    gum log --level warn "codex not found, skipping its plugins"
    return 0
  fi

  [[ -f "${file}" ]] || return 0

  local marketplaces installed
  marketplaces="$(codex plugin marketplace list 2>/dev/null || true)"
  installed="$(codex plugin list 2>/dev/null || true)"

  local source plugin market
  while IFS=$'\t' read -r source plugin; do
    [[ -n "${source}" ]] || continue
    [[ "${source}" != \#* ]] || continue

    market="${plugin##*@}"
    if ! grep -qE "^${market}[[:space:]]" <<<"${marketplaces}"; then
      gum log --level info "Adding codex marketplace ${source}"
      codex plugin marketplace add "${source}"
    fi

    if ! grep -qE "^${plugin}[[:space:]]+installed" <<<"${installed}"; then
      gum log --level info "Installing codex plugin ${plugin}"
      codex plugin add "${plugin}"
    fi
  done <"${file}"
}
