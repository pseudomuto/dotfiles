#!/bin/bash
set -euo pipefail

packages=("$@")

add_if_missing() {
  if ! package_is_installed "${1}"; then missing_packages+=("${1}"); fi
}

met() {
  missing_packages=()
  for pkg in "${packages[@]}"; do add_if_missing "${pkg}"; done
  return ${#missing_packages[@]}
}

meet() {
  update_package_manager || return $?
  install_packages "${missing_packages[@]}" || return $?
}
