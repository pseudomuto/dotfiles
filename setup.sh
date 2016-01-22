#!/bin/bash

# This will be run on the vagrant machine during provisions
# (as root)

TARGET=/home/vagrant/dotfiles

function install_packages {
  apt-get update -y -qq
  apt-get install -y -qq build-essential vim-nox git-core tmux ruby-dev
  gem install rake --no-ri --no-rdoc
}

function copy_files {
  rm -rf $TARGET && mkdir -p $TARGET
  cp -r /vagrant/* $TARGET
  cp /vagrant/.gitignore $TARGET/
  rm -rf $TARGET/submodules $TARGET/.vagrant
}

function setup_git {
  cd $TARGET
  git init . && git add -A && git commit -am "initial commit"
  git submodule add https://github.com/gmarik/vundle.git submodules/vundle
  git submodule add https://github.com/pseudomuto/oh-my-zsh.git submodules/oh-my-zsh
  git submodule add https://github.com/pseudomuto/git-freeze.git submodules/git-freeze
}

function change_owner {
  chown -R vagrant:vagrant $TARGET
}

install_packages
copy_files
setup_git
change_owner
