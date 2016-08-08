#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"

valid_options() {
  [ -n "${version}" ]
}

met() {
  [[ "$(which ruby-install && ruby-install -V)" =~ "ruby-install: ${version}" ]]
}

meet() {
  download_file "https://github.com/postmodern/ruby-install/archive/v${version}.tar.gz" /tmp || return $?
  extract_archive "/tmp/v${version}.tar.gz" || return $?

  pushd /tmp/ruby-install-${version} >/dev/null
  make install
  popd >/dev/null

  rm -rf /tmp/v${version}.tar.gz /tmp/ruby-install-${version}
}
