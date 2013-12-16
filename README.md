dotfiles
========

You know...dotfiles and such

# Initial Machine Setup

```shell
# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"

# common formulae
brew doctor
brew install git hub rbenv ruby-build zsh zsh-completions

# ruby versions
rbenv install 1.9.3-p444
rbenv install 1.9.3-p484
rbenv install 2.0.0-p247
rbenv install 2.0.0-p353
rbenv global 1.9.3-p484
rbenv rehash

# dotfiles
git clone git@github.com:pseudomuto/dotfiles.git ~/dotfiles
cd dotfiles
rake

# zsh is just better...add to /etc/shells before running
chsh -s /usr/local/bin/zsh <username>
```

Then exit your terminal and open a new one
