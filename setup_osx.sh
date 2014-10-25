source ./setup/brew.sh
source ./setup/rubies.sh
source ./setup/downloads.sh

# brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh
brew install vim
brew install tmux
brew install phantomjs
brew install git
brew install hub
brew install ruby-build
brew install chruby
brew install leiningen
brew doctor
brew upgrade

# rubies
mkdir ~/.rubies
ruby-build 2.1.2 ~/.rubies/2.1.2
ruby-build 2.1.3 ~/.rubies/2.1.2

# downloads
curl -L https://cachefly.alfredapp.com/Alfred_2.5.1_308.zip > ~/Downloads/alfredapp.zip
curl -L http://downloads.binaryage.com/TotalFinder-1.6.12.dmg > ~/Downloads/totalfinder.dmg
curl -L https://iterm2.com/downloads/stable/iTerm2_v2_0.zip > ~/Downloads/iterm2.zip
curl -L http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203065.dmg >
~/Downloads/sublime.dmg
curl -L https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5.dmg > ~/Downloads/vagrant.dmg

# Chrome
open https://www.google.ca/chrome/browser/#eula
