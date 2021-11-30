source "${HOME}/.shellrc"

export ZSH="$(brew --prefix)/share/oh-my-zsh"
export ZSH_THEME="robbyrussell"

# Allow [ or ] wherever you want
unsetopt nomatch

if [ -d "${ZSH}" ]; then
  fpath=("${HOME}/.zshrc.d/completion" $fpath)
  plugins=(fasd git gitfast history-substring-search)
  source "${ZSH}/oh-my-zsh.sh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -d /home/linuxbrew ]; then
  PROMPT='[remote]'$PROMPT
fi
