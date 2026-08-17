link_directory_recursively() {
  local src_dir="${1}"
  local dest_dir="${2}"

  find "${src_dir}" -type f -print0 | while IFS= read -r -d '' file; do
    link_name="${dest_dir}/${file#$src_dir/}"
    target_path="$(pwd)/${file}"

    mkdir -p "$(dirname ${link_name})"

    gum log --level info "Linking ${link_name}"
    if ! ln -sf "${target_path}" "${link_name}"; then
      gum log --level error "Failed linking ^^ dat file"
      exit 1
    fi
  done
}

# link_directory_recursively never prunes: rename or delete a file in this repo
# and its symlink out in $HOME lingers, dangling, forever. Sweep the stale ones
# before relinking.
#
# Only touches links pointing back into this repo. A dangling link belonging to
# some other tool is not ours to remove.
prune_dotfiles_links() {
  local dest_dir="${1}"
  [[ -d "${dest_dir}" ]] || return 0

  local repo="$(pwd)"
  local link

  while IFS= read -r -d '' link; do
    if [[ "$(readlink "${link}")" == "${repo}/"* ]] && [[ ! -e "${link}" ]]; then
      gum log --level warn "Pruning ${link}"
      rm -f "${link}"

      # Drop directories that only existed to hold what we just removed.
      rmdir -p "$(dirname "${link}")" 2>/dev/null || true
    fi
  done < <(find "${dest_dir}" -type l -print0 2>/dev/null)
}
