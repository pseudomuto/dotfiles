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
  local packages="automake fasd gcc gnupg gpg-agent jq keybase pinentry-mac the_silver_searcher tmux zsh"
  apply_delta "install base brew packages" "bin/apply packages ${packages}" || return $?
}

__install_linux_prerequisites() {
  local packages="autoconf build-essential curl jq silversearcher-ag tmux wget zsh"
  apply_delta "install base packages" "bin/apply packages ${packages}" || return $?
}

__install_prerequisites() {
  apply_delta "set permissions for /usr/local" "bin/apply permissions -p /usr/local --recursive" || return $?

  if osx; then __install_osx_prerequisites || return $?; fi
  if linux; then __install_linux_prerequisites || return $?; fi
}

__install_packages() {
  if linux; then
    apply_delta "install git" "bin/apply git -v 2.9.2" || return $?
    apply_delta "install hub" "bin/apply hub -v 2.2.3" || return $?
    apply_delta "install vim" "bin/apply vim -v 7.4.2149" || return $?
  else
    apply_delta "install git, hub and vim", "bin/apply packages git hub vim" || return $?
  fi
}

__install_development_environments() {
  # rubba-dub-dubby
  local system_ruby="--system"
  if osx; then system_ruby=""; fi # OSX is touchy about replacing the system ruby...

  apply_delta "install ruby-install" "bin/apply ruby-install -v 0.6.0" || return $?
  apply_delta "install ruby 2.3.1" "bin/apply ruby -v 2.3.1 ${system_ruby}" || return $?
  apply_delta "install ruby 2.2.5" "bin/apply ruby -v 2.2.5" || return $?
  apply_delta "install chruby" "bin/apply chruby -v 0.3.9" || return $?

  apply_delta "install golang" "bin/apply golang -v 1.6.3" || return $?

  local packages="python-dev python3-dev"
  if osx; then packages="python python3"; fi
  apply_delta "install python" "bin/apply packages ${packages}"
}

__install_source_dependencies() {
  apply_delta "fetch oh-my-zsh" "bin/apply source-repo -r robbyrussell/oh-my-zsh --sha f553724" || return $?
  apply_delta "fetch vundle" "bin/apply source-repo -r VundleVim/Vundle.vim --sha 4984767" || return $?
  apply_delta "update vundle" "bin/apply vundle -f ${HOME}/.vimrc.d/Vundlefile.vim" || return $?
}
