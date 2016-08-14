#!/bin/bash
set -euo pipefail

hack_idempotency=1

applied() {
  return ${hack_idempotency}
}

apply() {
  vim -u "${HOME}/.vimrc.d/Plugfile.vim" +PlugUpdate +PlugClean! +qall
  hack_idempotency=0
}
