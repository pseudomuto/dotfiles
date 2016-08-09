#!/bin/bash
set -euo pipefail

applied() {
  if ! osx; then return 0; fi
  [[ "$(which brew)" == "/usr/local/bin/brew" ]]
}

apply() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || return $?
}
