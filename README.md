dotfiles
========

You know...dotfiles and such

# Initial Machine Setup

```shell
# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"

# common formulae
brew doctor
brew install git hub chruby ruby-build zsh zsh-completions go node

# node packages
npm install -g coffee-script
npm install -g lineman

# ruby versions
ruby-build 1.9.3-p484 ~/.rubies/1.9.3-p484
ruby-build 2.0.0-p353 ~/.rubies/2.0.0-p353
ruby-build 2.1.0 ~/.rubies/2.1.0

# dotfiles
git clone git@github.com:pseudomuto/dotfiles.git ~/dotfiles
cd dotfiles
rake

# zsh is just better...add to /etc/shells before running
chsh -s /usr/local/bin/zsh <username>
```

Then exit your terminal and open a new one
