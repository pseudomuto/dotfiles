#!bin/bash
set -euo pipefail

define_option short=s long=shell variable=shell desc="The default shell for the current user"

valid_options() {
  [ -n "${shell+x}" ]
}

get_user_shell() {
  if osx; then
    echo $(dscl . -read /Users/davidmuto UserShell | cut -d' ' -f 2)
  else
    echo $(grep "^$(whoami)" /etc/passwd | cut -d ':' -f 7)
  fi
}

met() {
  # if the shell isn't available don't error out
  if ! which "${shell}" >/dev/null; then return 0; fi

  local user_shell="$(get_user_shell)"
  [[ "${user_shell}" == "$(which ${shell})" ]]
}

meet() {
  sudo chsh -s "$(which ${shell})" "$(whoami)" || return $?
}
