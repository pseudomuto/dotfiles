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
