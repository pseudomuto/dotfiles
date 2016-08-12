#!/bin/bash
set -euo pipefail

define_option short=v long=version variable=version desc="The version to install"
define_option short=s long=system variable=system default=0 value=1 desc="Whether or not to install as the system ruby"

USER_RUBIES="${HOME}/.rubies"

valid_options() {
  [ -n "${version+x}" ] && [ -n "${version}" ]
}

is_system() {
  [[ "${system}" -eq "1" ]]
}

applied() {
  if is_system; then
    [[ "$(which ruby && ruby -v)" =~ "ruby ${version}" ]]
  else
    [[ -d "${USER_RUBIES}/ruby-${version}" ]]
  fi
}

apply() {
  if is_system; then
    ruby-install --system ruby "${version}" -- --disable-install-doc || return $?
  else
    # try to grab a travis prebuilt ruby first, fallback to building one
    ${HOME}/bin/install_ruby ruby "${version}" || ruby-install ruby "${version}" -- --disable-install-doc || return $?
  fi
}
