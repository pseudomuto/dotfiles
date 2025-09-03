kubectl-short-aliases() {
  alias k='kubectl'
  alias kgp='k get pods'
  alias kgn='k get namespaces'
  alias kgpn='k get pods -o custom-columns=NAME:.metadata.name --no-headers'
  alias kg='k get'

  alias kbn='browse-nodes'
  alias kbp='browse-running-pods'
  # consider using browse-running-pods instead of these
  alias kl='list-running-containers-by-pod | fzf --preview "kubectl logs {1} {2}" --height=100% --preview-window=right:75%:wrap'
  alias kex='exec-with-bash-if-available $(list-running-containers-by-pod | fzf)'
  alias kx='exec-pod'
  alias kdesc='k describe $(k get pods -o name | fzf)'
}

# USAGE: exec-pod FUZZY_NAME [CONTAINER_NAME]
# The "I'm feeling lucky" way to exec into pods in the current context/namespace
# Will prompt to select container name if none given and more than one available
exec-pod() {
  local type=$1
  local container=$2
  local pod

  if ! [ "$type" ]; then
    echo "Please specify pod type"
    return 1
  fi

  pod=$(kubectl get pods -o=custom-columns=NAME:.metadata.name | grep -i --max-count=1 "^${type}")

  if [ -z "$pod" ]; then
    echo "No pods with name matching '${type}' found"
    return 1
  fi

  if [[ -z "$container" ]]; then
    container=$(kubectl get pod "$pod" -ojsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' --no-headers | fzf -1 --prompt "select container > " --height=10%)
  fi

  if [ -n "$container" ]; then
    printf "Entering pod \\033[0;32m%s\\033[0m container \\033[0;32m%s\\033[0m\\n" "$pod" "$container"
    exec-with-bash-if-available "$pod" "--container=$container"
  fi
}

exec-with-bash-if-available() {
  kubectl exec -ti "$@" -- /bin/sh -c "if test -x /bin/bash; then exec /bin/bash; else exec /bin/sh; fi"
}

list-running-containers-by-pod() {
  kubectl get pods "$@" --field-selector status.phase=Running -o json | jq -r '.items[] | . as $item | .spec.containers[] | $item.metadata.name + " --container=" + .name'
}

# USAGE: browse-running-pods [KUBECTL_ARGS]
# Lists pods running in the target namespace (current by default) in a browser showing DESCRIBE output for the selected pod
# Hit enter to see the pod's containers in a browser showing LOGS for the selected container
# Hit enter on a container name to EXEC into that container (with bash if available)
# Any extra args given will be passed to kubectl (e.g. use to specify namespace, context or label selector)
browse-running-pods() {
  local all_pods fzf_opts viewer pod container

  all_pods=$(kubectl get pods "$@" --field-selector status.phase=Running -o=custom-columns=NAME:.metadata.name)
  fzf_opts='--preview-window=right:80%:wrap --layout=reverse --height=100% --header="Use Shift+arrow/PgUp/PgDn to scroll preview" --bind=pgup:preview-page-up,pgdn:preview-page-down'

  if [[ -z $all_pods ]]; then
    echo "No running pods found in this namespace"
    return 1
  fi

  if [ -n "$(command -v bat)" ]; then
    viewer="bat --color=always -l yaml"
  else
    viewer="cat"
  fi

  pod=$(echo "$all_pods" | FZF_DEFAULT_OPTS=$fzf_opts fzf --prompt "select pod > " --preview "kubectl describe pod {} $* | $viewer" --header-lines=1 --no-clear)

  if [ -z "$pod" ]; then
    return
  fi

  container=$(kubectl get pod "$pod" "$@" -ojsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' --no-headers | FZF_DEFAULT_OPTS=$fzf_opts fzf --prompt "select container > " --preview="kubectl logs $* $pod -c {} --tail=1000 | $viewer")

  if [ -z "$container" ]; then
    return
  fi

  printf "Entering pod \\033[0;32m%s\\033[0m container \\033[0;32m%s\\033[0m\\n" "$pod" "$container"

  exec-with-bash-if-available "$pod" "$@" --container="$container"
}

browse-nodes() {
  local viewer node zone fzf_opts query
  query=$1
  if [ -n "$query" ]; then shift; fi

  if [ -n "$(command -v bat)" ]; then
    viewer="bat --color=always -l yaml"
  else
    viewer="cat"
  fi
  fzf_opts='--preview-window=right:80%:wrap --layout=reverse --height=100% --header="Use Shift+arrow/PgUp/PgDn to scroll preview, Enter to ssh" --bind=pgup:preview-page-up,pgdn:preview-page-down'

  node=$(kubectl get nodes "$@" -o=custom-columns=NAME:.metadata.name --no-headers | FZF_DEFAULT_OPTS=$fzf_opts fzf -q "$query" --preview "kubectl describe node {} $* | $viewer")

  if [[ -n $node ]]; then
    ssh-node "$node"
  fi
}

find-colocated-pods() {
  local node
  node=$(kubectl get pod "$1" -o jsonpath='{ .spec.nodeName }')
  if [[ -z $node ]]; then
    echo "Pod $1 not found"
    return 1
  fi

  kubectl get pods --field-selector "spec.nodeName=$node" --all-namespaces --sort-by "status.phase"
}

ssh-node() {
  local node zone
  node=$1
  zone=$(kubectl get node "$node" -o jsonpath='{ .metadata.labels.failure-domain\.beta\.kubernetes\.io/zone }')
  gcloud compute ssh "$node" --zone="$zone"
}

ssh-node-for-pod() {
  local node
  node=$(kubectl get pod "$1" -o jsonpath='{ .spec.nodeName }')
  if [[ -z $node ]]; then
    return 1
  fi

  ssh-node "$node"
}

kubectl-current-ctx() {
  kubectl config current-context
}

kubectl-current-ns() {
  local ns
  ns=$(kubectl config view --minify --output "jsonpath={..namespace}" 2>/dev/null)
  ns=${ns:-default}
  echo "$ns"
}

kubernetes-current-context-info() {
  echo "$(kubectl-current-ctx)/$(kubectl-current-ns)"
}

# if there's 1 match, switch, otherwise show fzf
grep-then-fzf() {
  local match=$1
  shift
  local input=$1
  shift
  local prompt=$1
  shift

  if [[ -n $match ]]; then
    local exact_match
    exact_match=$(echo "$input" | grep "^$match$")
    if [ -n "$exact_match" ]; then
      echo "$exact_match"
    else
      echo "$input" | grep "$match" | fzf -1 -q "$match" --prompt "${prompt} (matches) >"
    fi
  else
    echo "$input" | fzf --prompt "${prompt} >"
  fi
}

kns() {
  local ns=$1
  local all_ns new_ns
  all_ns=$(kubectl get namespaces -o=custom-columns=NAME:.metadata.name --no-headers)
  new_ns=$(grep-then-fzf "${ns}" "${all_ns}" "k8s namespace")
  test -z "$new_ns" && return 1 # allow ctrl-c
  kubectl config set-context "$(kubectl-current-ctx)" --namespace="${new_ns}" >/dev/null
  echo "Switched to namespace \"${new_ns}\"."
}
alias chns=kns

kctx() {
  local ctx=$1
  local all_ctx new_ctx
  all_ctx=$(kubectl config get-contexts -o name --no-headers)
  new_ctx=$(grep-then-fzf "${ctx}" "${all_ctx}" "k8s context")
  test -z "$new_ctx" && return 1 # allow ctrl-c
  kubectl config use-context "${new_ctx}"

  local namespace=$2
  if [[ -n "$namespace" || $(kubectl-current-ns) = "default" ]]; then
    kns "$namespace"
  fi
}
alias chctx=kctx

# Only setup zsh completions if we're actually in zsh and compdef is available
if [[ -n "$ZSH_VERSION" ]] && command -v compdef >/dev/null 2>&1; then
  _kns() {
    local namespaces
    namespaces=($(kubectl get namespaces -o=custom-columns=NAME:.metadata.name --no-headers))
    compadd "${namespaces[@]}"
  }
  compdef _kns kns chns

  _kctx() {
    _arguments -C '1:context:->list_contexts' '2:namespace:->list_namespaces'

    case "$state" in
    list_contexts)
      local contexts
      contexts=($(kubectl config get-contexts -o name))
      compadd "${contexts[@]}"
      ;;
    list_namespaces)
      local namespaces
      namespaces=($(kubectl get namespaces -o=custom-columns=NAME:.metadata.name --no-headers --context="${line[1]}"))
      compadd "${namespaces[@]}"
      ;;
    esac
  }
  compdef _kctx kctx chctx
fi
