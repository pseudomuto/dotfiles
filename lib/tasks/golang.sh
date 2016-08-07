#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"

valid_options() {
  [ -n "${version+x}" ]
}

met() {
  [[ "$(which go && go version)" =~ "go version go${version}" ]]
}

meet() {
  local os_type=$(uname | tr '[:upper:]' '[:lower:]')
  local package_name="go${version}.${os_type}-amd64.tar.gz"

  download_file "https://storage.googleapis.com/golang/${package_name}" /tmp || return $?
  extract_archive "/tmp/${package_name}" "/usr/local" || return $?
  rm "/tmp/${package_name}"
}
