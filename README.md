dotfiles
========

You know...dotfiles and such

# Initial Machine Setup

## OSX

```shell
# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"

# common formulae
brew doctor
brew install git hub chruby ruby-build zsh zsh-completions go node

# zsh is just better...add to /etc/shells before running
chsh -s /usr/local/bin/zsh <username>
```

## Ubuntu

```shell

sudo apt-get update
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git node

# chruby
wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz
tar -xzvf chruby-0.3.8.tar.gz
cd chruby-0.3.8/
sudo make install
cd ../ && rm -rf chruby-0.3.8 chruby-0.3.8.tar.gz

# Ruby Build
git clone https://github.com/sstephenson/ruby-build.git
cd ruby-build
sudo ./install.sh
cd ../ && rm -rf ruby-build

# Hub
git clone git://github.com/github/hub.git && cd hub
sudo rake install
cd ../ && rm -rf hub

# zsh is just better...add to /etc/shells before running
sudo chsh -s /usr/bin/zsh <username>
```

## Common

```shell
# ruby versions
ruby-build 1.9.3-p484 ~/.rubies/1.9.3-p484
ruby-build 2.0.0-p353 ~/.rubies/2.0.0-p353
ruby-build 2.1.0 ~/.rubies/2.1.0

# node packages
npm install -g coffee-script
npm install -g lineman

# dotfiles
git clone git@github.com:pseudomuto/dotfiles.git ~/dotfiles
cd dotfiles
rake
```

# Testing with Vagrant

```shell
$ vagrant up
$ vagrant ssh
```

Now follow the Ubuntu steps above, but instead of cloning the dotfiles repo, you can just access the local copy in `/vagrant`

## Starting from scratch

    $ vagrant destroy && rm -rf .vagrant
