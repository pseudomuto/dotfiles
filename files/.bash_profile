[ -f "${HOME}/.profile" ] && source "${HOME}/.profile"
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ${HOME}/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
