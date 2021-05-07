export ZSH="/usr/local/share/oh-my-zsh"
export ZSH_THEME="robbyrussell"

# Allow [ or ] wherever you want
unsetopt nomatch

if [ -d "${ZSH}" ]; then
  fpath=("${HOME}/.zshrc.d/completion" $fpath)
  plugins=(fasd osx git gitfast history-substring-search)
  source "${ZSH}/oh-my-zsh.sh"
fi

source "${HOME}/.shellrc"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
