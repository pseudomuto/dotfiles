#!/usr/bin/env bash
set -euo pipefail

PKGS_ADD=(
  buf
  direnv
  nix
  omarchy-zsh
  tree
)

PKGS_AUR=(
  beeper-v4-bin
  func-e-bin
  git-credential-oauth
  google-chrome
  keybase-bin
  openai-codex-bin
)

PKGS_REMOVE=(
  chromium
  spotify
  typora
)

declare -A REPOS
REPODIR="${HOME}/.local/share"
REPOS=(
  [ohmyzsh]=ohmyzsh/ohmyzsh
)

main() {
  omarchy-pkg-drop "${PKGS_REMOVE[@]}"
  omarchy-install-terminal ghostty
  omarchy-pkg-add "${PKGS_ADD[@]}"
  omarchy-pkg-aur-add "${PKGS_AUR[@]}"

  # Clone/update repos
  for repo in "${REPOS[@]}"; do
    local name="${repo##*/}"

    if [[ -d "${REPODIR}/${name}" ]]; then
      gum log --level info "Updating ${repo}..."
      pushd "${REPODIR}/${name}" >/dev/null
      git pull origin "$(git branch --show-current)"
      popd >/dev/null
    else
      gum log --level info "Cloning ${name}..."
      git clone --depth 1 "https://github.com/${repo}.git" "${REPODIR}/${name}"
    fi
  done

  # Set zsh as default shell if found.
  if command -v zsh >/dev/null; then
    gum log --level info "Setting $(whoami)'s shell to $(which zsh)..."
    sudo chsh -s "$(which zsh)" "$(whoami)" >/dev/null 2>&1
  fi
}

main "$@"
