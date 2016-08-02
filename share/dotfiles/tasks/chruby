#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"

valid_options() {
  [ -n "${version+x}" ]
}

met() {
  [[ "$(which chruby-exec && chruby-exec --version)" =~ "chruby version ${version}" ]]
}

meet() {
  download_file "https://github.com/postmodern/chruby/archive/v${version}.tar.gz" /tmp || return $?
  extract_archive "/tmp/v${version}.tar.gz" || return $?

  pushd /tmp/chruby-${version} >/dev/null
  sudo scripts/setup.sh || return $?
  popd >/dev/null

  rm -rf /tmp/v${version}.tar.gz /tmp/chruby-${version}
}
