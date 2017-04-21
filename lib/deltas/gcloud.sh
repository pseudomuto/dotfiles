#!/bin/bash
set -euo pipefail

applied() {
  [[ -d "${HOME}/google-cloud-sdk" ]]
}

apply() {
  local package_host="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads"
  local package_name="google-cloud-sdk-152.0.0-darwin-x86_64.tar.gz"

  download_file "${package_host}/${package_name}" /tmp || return $?
  extract_archive "/tmp/${package_name}" "${HOME}" || return $?
  rm "/tmp/${package_name}"
}
