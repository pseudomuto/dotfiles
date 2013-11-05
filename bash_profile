source /opt/boxen/env.sh
source ~/.git-completion
source ~/.env

alias bi="bundle install"
alias be="bundle exec"
alias gl="git log --date=short --pretty=format:'%Cgreen%h %Cblue%cd %Cred%an%Creset: %s'"

### Lineman for Shopify
export LINEMAN_AUTO_START=false

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
