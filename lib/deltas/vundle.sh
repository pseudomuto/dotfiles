#!/bin/bash
set -euo pipefail

define_option short=f long=file variable=file desc="The path to the vundlefile"

valid_options() {
  [ -n "${file+x}" ]
}

applied() {
  local wanted=$(cat "${file}" | grep Plugin | awk -F "/" '{ print substr($2, 1, length($2) - 1) } ' | sort)
  local found=$(ls -A ~/.vim/bundle | sort)

  [[ "${found}" == "${wanted}" ]]
}

apply() {
  vim -u "${file}" +VundleUpdate +qall

  pushd "${HOME}/.vim/bundle/command-t/ruby/command-t" >/dev/null
  ruby extconf.rb || return $?
  make clean && make || return $?
  popd >/dev/null
}
