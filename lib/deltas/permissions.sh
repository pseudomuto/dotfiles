#!/bin/bash
set -euo pipefail

define_option short=p long=path variable=dir_path desc="The path to set permissions for"
define_option short=r long=recursive variable=recursive value=1 default=0 desc="Whether or not to set permissions recursively"

group_name() {
  local name="root"
  if osx; then name="admin"; fi

  echo "${name}"
}

valid_options() {
  [ -n "${dir_path+x}" ]
}

applied() {
  [[ -O "${dir_path}" ]]
}

apply() {
  sudo chown -R $(whoami):$(group_name) "${dir_path}"
}
