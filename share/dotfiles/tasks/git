#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"

valid_options() {
  [ -n "${version}" ]
}

met() {
  [[ "$(which git && git --version)" =~ "git version ${version}" ]]
}

meet() {
  install_packages libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

  download_file "https://github.com/git/git/archive/v${version}.tar.gz" /tmp || return $?
  extract_archive "/tmp/v${version}.tar.gz" || return $?

  pushd /tmp/git-${version} >/dev/null
  make configure || return $?
  ./configure --prefix=/usr/local || return $?
  make all || return $?
  sudo make install || return $?
  popd >/dev/null

  rm -rf /tmp/v${version}.tar.gz /tmp/git-${version}
}
