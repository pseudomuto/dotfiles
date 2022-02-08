# dotfiles

Installs all my dotfiles, useful packages, and some light system config (default shell, secrets, etc.)

## Initial setup

* Add the private EJSON key to $EJSON_KEYDIR (see files/shell/exports)
* Run `./install' to install nix and home-manager
* Run './apply` to get the first _real_ generation

## Ongoing

Simply make any changes and run `./apply`.
