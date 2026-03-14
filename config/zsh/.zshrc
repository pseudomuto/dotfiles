# If omarchy, load that shit.
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

# OhMyZsh is kinda my jam.
plugins=(fasd direnv git gitfast history-substring-search kube-ps1)
source "${ZSH}/oh-my-zsh.sh"

eval "$(mise activate zsh)"
