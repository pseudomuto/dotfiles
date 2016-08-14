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
  if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
  else
    eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
  fi
fi

if [[ $OSTYPE == darwin* ]]; then
  /usr/local/bin/fortune smac
fi
if [[ $OSTYPE == linux* ]]; then
  /usr/games/fortune smac
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
