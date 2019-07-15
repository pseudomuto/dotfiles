source "${HOME}/.shellrc"

# cloudplatform: add Shopify clusters to your local kubernetes config
export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}${HOME}/.kube/config:${HOME}/.kube/config.shopify.cloudplatform

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
