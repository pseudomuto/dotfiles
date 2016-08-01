#!/bin/bash
set -euo pipefail

package_manager="apt"

# OSX overrides
if [[ "$OSTYPE" =~ "^darwin" ]]; then
  package_manager="brew"
fi

package_is_installed() {
  case "${package_manager}" in
    apt) dpkg --get-selections | grep -v deinstall | cut -f 1 | grep -e "^$1$" >/dev/null || return $?;;
    brew) brew ls ${1} >/dev/null || return $?
  esac
}

update_package_manager() {
  case "${package_manager}" in
    apt) sudo apt-get -y update || return $?;;
    brew) brew update || return $?;;
  esac
}

install_packages() {
  case "${package_manager}" in
    apt) sudo apt-get -y install "$@" || return $? ;;
    brew) brew install "$@" || return $? ;;
  esac
}

