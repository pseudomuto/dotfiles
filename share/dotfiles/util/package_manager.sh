#!/bin/bash
set -euo pipefail

package_manager="apt"

# OSX overrides
if [[ "$OSTYPE" =~ "^darwin" ]]; then
  package_manager="brew"
fi

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

