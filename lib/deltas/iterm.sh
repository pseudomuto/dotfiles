#!/bin/bash
set -euo pipefail

applied() {
  # not a failure, but nothing to do for linux
  if linux; then return 0; fi

  [[ -d /Applications/iTerm.app ]]
}

apply() {
  download_file "https://iterm2.com/downloads/stable/iTerm2-3_0_5.zip" /tmp || return $?
  extract_archive "/tmp/iTerm2-3_0_5.zip" || return $?

  sudo cp -R /tmp/iTerm.app /Applications
  rm -rf /tmp/iTerm*
}
