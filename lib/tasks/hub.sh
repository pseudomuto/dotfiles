#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"

valid_options() {
  [ -n "${version+x}" ]
}

met() {
  [[ "$(which hub && hub version)" =~ "hub version ${version}" ]]
}

meet() {
  download_file "https://github.com/github/hub/archive/v${version}.tar.gz" /tmp || return $?
  extract_archive "/tmp/v${version}.tar.gz" || return $?

  pushd /tmp/hub-${version} >/dev/null
  ./script/build -o /usr/local/bin/hub
  popd >/dev/null

  rm -rf /tmp/v${version}.tar.gz /tmp/hub-${version} /tmp/go*
}
