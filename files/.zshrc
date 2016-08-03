# Path to your oh-my-zsh configuration.
ZSH="${HOME}/.zshrc.d/oh-my-zsh"
ZSH_THEME="robbyrussell"

# Allow [ or ] wherever you want
unsetopt nomatch

fpath=("${HOME}/.zshrc.d/completion" $fpath)
plugins=(fasd osx gitfast history-substring-search knife)

source "${ZSH}/oh-my-zsh.sh"
source "${HOME}/.shellrc"

if [[ `uname` == "Darwin" ]]; then
  [[ ! -f /etc/profile.d/chruby.sh ]] && chruby 2.3.0

  if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
  else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
  fi
fi
