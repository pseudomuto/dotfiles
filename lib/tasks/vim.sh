#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"

valid_options() {
  [ -n "${version}" ]
}

met() {
  if ! which vim >/dev/null; then return 1; fi

  local version_num="$(echo ${version} | awk -F '.' '{ printf "%s.%s", $1, $2 }')"
  local patch_num="$(echo ${version} | awk -F '.' '{ printf "%s", $3 }')"
  local version_info=$(vim --version)

  [[ "${version_info}" =~ "Vi IMproved ${version_num}" ]] && \
    [[ "${version_info}" =~ "Included patches: 1-${patch_num}" ]]
}

meet() {
  if linux; then install_packages libncurses5-dev || return $?; fi

  download_file "https://github.com/vim/vim/archive/v${version}.tar.gz" /tmp || $?
  extract_archive "/tmp/v${version}.tar.gz" || return $?

  pushd /tmp/vim-${version} >/dev/null

  ./configure \
    --with-features=huge \
    --prefix=/usr/local \
    --enable-rubyinterp \
    --enable-pythoninterp \
    --enable-python3interp || return $?

  make && make install
  popd >/dev/null

  rm -rf /tmp/vim-${version}
}
