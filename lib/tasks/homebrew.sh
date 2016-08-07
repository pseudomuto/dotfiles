#!/bin/bash
set -euo pipefail

met() {
  if ! osx; then return 0; fi
  [[ "$(which brew)" == "/usr/local/bin/brew" ]]
}

meet() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || return $?
}
