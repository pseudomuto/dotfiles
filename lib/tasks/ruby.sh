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

met() {
  if is_system; then
    [[ "$(which ruby && ruby -v)" =~ "ruby ${version}" ]]
  else
    [[ -d "${USER_RUBIES}/ruby-${version}" ]]
  fi
}

meet() {
  if is_system; then
    ruby-install --system ruby "${version}" -- --disable-install-doc || return $?
  else
    ${HOME}/bin/install_ruby ruby "${version}" || return $?
  fi
}
