#!/bin/bash
set -euo pipefail

define_option short=r long=repo variable=repo desc="The repository (owner/repo) to clone"
define_option short=d long=target-dir variable=target_dir desc="The target directory for this clone"
define_option short=s long=sha variable=sha desc="The SHA to check out"

valid_options() {
  if [ -z "${repo+x}" ] || [ -z "${sha+x}" ]; then return 1; fi

  target_dir="/usr/local/src/${repo##*/}"
}

applied() {
  if [ ! -d "${target_dir}" ]; then return 1; fi

  pushd "${target_dir}" >/dev/null
  local head_sha=$(git rev-parse --short HEAD)
  popd >/dev/null

  [ "${head_sha}" == "${sha}" ]
}

apply() {
  if [ ! -d "${target_dir}" ]; then
    mkdir -p "${target_dir}"
    git clone "https://github.com/${repo}" "${target_dir}"
  fi

  pushd "${target_dir}" >/dev/null
  git fetch --all -p
  git checkout "${sha}"
  popd >/dev/null
}
