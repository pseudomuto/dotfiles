#!/bin/bash
set -euo pipefail

install_osx_prerequisites() {
  local packages="automake fasd gcc gnupg gpg-agent jq pinentry-mac the_silver_searcher tmux zsh"
  task "install base brew packages" "bin/install packages ${packages}" || return $?
}

install_linux_prerequisites() {
  local packages="autoconf build-essential curl jq silversearcher-ag tmux wget zsh"
  task "install base packages" "bin/install packages ${packages}" || return $?
}

install_prerequisites() {
  task "symlink files" "bin/install files -s files" || return $?
  task "set permissions for /usr/local" "bin/install permissions -p /usr/local --recursive" || return $?

  if osx; then install_osx_prerequisites || return $?; fi
  if linux; then install_linux_prerequisites || return $?; fi
}

install_packages() {
  task "install git" "bin/install git -v 2.9.2" || return $?
  task "install hub" "bin/install hub -v 2.2.3" || return $?
  task "install vim" "bin/install vim -v 7.4.2149" || return $?
}

install_development_environments() {
  # rubba-dub-dubby
  task "install ruby-install" "bin/install ruby-install -v 0.6.0" || return $?
  task "install system ruby 2.3.1" "bin/install ruby -v 2.3.1 --system" || return $?
  task "install user ruby 2.2.5" "bin/install ruby -v 2.2.5" || return $?
  task "install chruby" "bin/install chruby -v 0.3.9" || return $?

  task "install golang" "bin/install golang -v 1.6.3" || return $?

  local packages="python-dev python3-dev"
  if osx; then packages="python python3"; fi
  task "install python" "bin/install packages ${packages}"
}

install_source_dependencies() {
  task "fetch oh-my-zsh" "bin/install source-repo -r robbyrussell/oh-my-zsh --sha f553724" || return $?
  task "fetch vundle" "bin/install source-repo -r VundleVim/Vundle.vim --sha 4984767" || return $?
  task "update vundle" "bin/install vundle -f ${HOME}/.vimrc.d/Vundlefile.vim" || return $?
}
