# If omarchy, load that shit.
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

# OhMyZsh is kinda my jam.
plugins=(fasd direnv git gitfast history-substring-search kube-ps1)
[[ -f "${HOME}/.local/share/fasd/fasd" ]] && source "${HOME}/.local/share/fasd/fasd"
source "${ZSH}/oh-my-zsh.sh"

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="/Users/pseudomuto/.config/zsh/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
)
for opt in "${enabled_opts[@]}"; do setopt "$opt"; done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
  HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
)
for opt in "${disabled_opts[@]}"; do unsetopt "$opt"; done
unset opt disabled_opts

# macOS-specific PATH additions
export PATH="$PATH:$HOME/.local/bin:/usr/local/bin"

unsetopt nomatch

eval "$(mise activate zsh)"
