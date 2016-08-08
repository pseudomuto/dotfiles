#!/bin/bash

source_tar="https://github.com/pseudomuto/dotfiles/archive/vnext.tar.gz"
temp_dir="$(mktemp -u)"
clone_dir="${HOME}/dotfiles"

main() {
  mkdir -p "${temp_dir}"
  mkdir -p "${clone_dir}"

  curl -L "${source_tar}" > "${temp_dir}/dotfiles.tar.gz"
  tar xzf "${temp_dir}/dotfiles.tar.gz" -C "${clone_dir}" --strip-components=1
  rm -rf "${temp_dir}"

  cd "${clone_dir}"
  bin/setup
}

main "$@"
