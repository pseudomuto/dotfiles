#!/usr/bin/env bash
set -euo pipefail

main() {
  # install dev tools
  mise install

  handle_keybase
}

handle_keybase() {
  if ! keybase whoami >/dev/null; then
    gum log --level warn "Not logged into Keybase"
    return
  fi

  mkdir -p ~/.config/keybase
  if [[ -f ~/.config/keybase/imported_ts ]]; then
    gum log --level info "GPG keys up to date"
    return
  fi

  gum log --level info "Setting up keybase"
  keybase pgp export | gpg --import
  keybase pgp export -s | gpg --allow-secret-key-import --import
  gum log --level warn "You need to this key! (trust > 5 > y > quit)"
  gpg --edit-key 6EA84352485608D0
  date >~/.config/keybase/imported_ts
}

main "$@"
