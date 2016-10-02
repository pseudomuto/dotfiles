# Path to your oh-my-zsh configuration.
ZSH="${HOME}/.zshrc.d/oh-my-zsh"
ZSH_THEME="crunch"
plugins=(history-substring-search fasd git osx ruby bundler brew go)

source $ZSH/oh-my-zsh.sh

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


# Allow [ or ] wherever you want
unsetopt nomatch

fpath=("${HOME}/.zshrc.d/completion" $fpath)
#plugins=(fasd osx gitfast history-substring-search knife)

# source "${ZSH}/oh-my-zsh.sh"

source "${HOME}/.shellrc"

if [[ $OSTYPE == darwin* ]]; then
  /usr/local/bin/fortune smac
fi
if [[ $OSTYPE == linux* ]]; then
  /usr/games/fortune smac
fi

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
