{ config, lib, pkgs, ...}:
{
  _module.args.isLinux = true;

  imports = [
    ./common.nix
    ../apps/cockroachdb.nix
    ../apps/ejson.nix
    ../apps/git.nix
    ../apps/go.nix
    ../apps/gpg.nix
    ../apps/keybase.nix
    ../apps/nix.nix
    ../apps/shell.nix
    ../apps/tmux.nix
    ../apps/vim.nix
  ];

  home.packages = with pkgs; [
    vault
  ];
}
