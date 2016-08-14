#!/bin/bash
set -euo pipefail

applied() {
  local wanted=$(cat ~/.vimrc.d/Plugfile.vim | pcregrep -o1 "^\s*Plug\s+'[^/]+/([^']+)'.*" | sort)
  local found=$(ls -A ~/.vim/bundle | sort)

  [[ "${found}" == "${wanted}" ]]
}

apply() {
  vim -u "${HOME}/.vimrc.d/Plugfile.vim" +PlugUpgrade +PlugInstall +PlugClean! +qall
}
