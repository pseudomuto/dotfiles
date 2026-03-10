#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="${HOME}/.config"

main() {
  find ./config -type f -print0 | while IFS= read -r -d '' file; do
    # link_name="$(basename ${file})"
    link_name="${DEST_DIR}/${file#./config/}"
    target_path="$(pwd)/${file#*/}"

    gum log --level info "Linking ${link_name}"
    mkdir -p "$(dirname ${link_name})"

    if ! ln -sf "${target_path}" "${link_name}"; then
      gum log --level error "Failed linking ^^ dat file"
      exit 1
    fi
  done
}

main "$@"
