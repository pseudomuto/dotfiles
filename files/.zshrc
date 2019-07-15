# Path to your oh-my-zsh configuration.
ZSH="${HOME}/.zshrc.d/oh-my-zsh"
ZSH_THEME="robbyrussell"

# Allow [ or ] wherever you want
unsetopt nomatch

fpath=("${HOME}/.zshrc.d/completion" $fpath)
plugins=(fasd osx gitfast history-substring-search knife)

source "${ZSH}/oh-my-zsh.sh"
source "${HOME}/.shellrc"

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}${HOME}/.kube/config:${HOME}/.kube/config.shopify.cloudplatform

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
