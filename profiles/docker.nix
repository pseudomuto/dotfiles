{ config, lib, pkgs, ...}:
{
  # Same as linux, only without ejson and keybase since they'd require the
  # private key to be on the machine.
  imports = [
    ./common.nix
    ../apps/cockroachdb.nix
    ../apps/git.nix
    ../apps/go.nix
    ../apps/gpg.nix
    ../apps/nix.nix
    ../apps/nvim.nix
    ../apps/shell.nix
    ../apps/tmux.nix
  ];
}
