#!/bin/bash
set -euo pipefail

initialize_phase() {
  apply_delta "install package manager" "bin/apply homebrew" || return $?
  apply_delta "symlink files" "bin/apply files -s files" || return $?
}

finalize_phase() {
  apply_delta "Set default shell to zsh" "bin/apply set-shell -s zsh" || return $?
}

run_install_phase() {
  run_phase "Install prerequisites" "__install_prerequisites"
  run_phase "Install development packages" "__install_development_environments"
  run_phase "Install applications" "__install_packages"
  run_phase "Install source dependencies" "__install_source_dependencies"
}

__install_osx_prerequisites() {
  local packages="automake fasd gcc gnupg gpg-agent jq pinentry-mac reattach-to-user-namespace sbt the_silver_searcher tmux zsh"
  packages="${packages} yarn"

  apply_delta "install base brew packages" "bin/apply packages ${packages}" || return $?
}

__install_linux_prerequisites() {
  local packages="autoconf build-essential curl jq silversearcher-ag tmux wget zsh"
  apply_delta "install base packages" "bin/apply packages ${packages}" || return $?
}

__install_prerequisites() {
  if osx; then __install_osx_prerequisites || return $?; fi
  if linux; then __install_linux_prerequisites || return $?; fi
}

__install_packages() {
  if linux; then
    apply_delta "install git" "bin/apply git -v 2.20.1" || return $?
    apply_delta "install hub" "bin/apply hub -v 2.13.0" || return $?
    apply_delta "install vim" "bin/apply vim -v 8.1.2383" || return $?
  else
    apply_delta "install git" "bin/apply packages git" || return $?
    apply_delta "install hub" "bin/apply packages hub" || return $?
    apply_delta "install vim" "bin/apply packages vim" || return $?
    apply_delta "install iterm" "bin/apply iterm" || return $?
  fi
}

__install_development_environments() {
  # rubba-dub-dubby
  local system_ruby="--system"
  if osx; then system_ruby=""; fi # OSX is touchy about replacing the system ruby...

  # For now, I'm going to let dev handle rubies
  if ! osx; then
    apply_delta "install ruby-install" "bin/apply ruby-install -v 0.7.0" || return $?
    apply_delta "install ruby 2.3.1" "bin/apply ruby -v 2.6 ${system_ruby}" || return $?
    apply_delta "install chruby" "bin/apply chruby -v 0.3.9" || return $?
  fi

  local packages="python-dev python3-dev"
  if osx; then packages="python python3"; fi
  apply_delta "install python" "bin/apply packages ${packages}"

  apply_delta "install golang" "bin/apply golang -v 1.8.1" || return $?
  apply_delta "install google cloud sdk" "bin/apply gcloud"
}

__install_source_dependencies() {
  apply_delta "fetch oh-my-zsh" "bin/apply source-repo -r robbyrussell/oh-my-zsh --sha 66bae5a5" || return $?
  apply_delta "plug vim" "bin/apply vim-plug" || return $?
  apply_delta "install powerline fonts" "bin/apply source-repo --repo powerline/fonts --sha a83a867 --cmd ./install.sh" || return $?
}
