{ pkgs, lib, ...}:
let
  git = import apps/git.nix { pkgs=pkgs; };
  go = import apps/go.nix { pkgs=pkgs; };
  gpg = import apps/gpg.nix { pkgs=pkgs; };
  nix = import apps/nix.nix { pkgs=pkgs; };
  nvim = import apps/nvim.nix { pkgs=pkgs; };
  tmux = import apps/tmux.nix { pkgs=pkgs; };
  shell = import apps/shell.nix { lib=lib; pkgs=pkgs; };
in
{
  apps = [
    git
    go
    gpg
    nix
    nvim
    tmux
    shell
  ];

  files = {
    ".agignore" = { source = files/.agignore; };
    ".gemrc" = { source = files/.gemrc; };
    ".pryrc" = { source = files/.pryrc; };
    "bin/docker-clean" = { source = files/bin/docker-clean; };
  };

  packages = [
    pkgs.bazelisk
    pkgs.direnv
    pkgs.fasd
    pkgs.fzf
    pkgs.gcc
    pkgs.google-cloud-sdk
    pkgs.keybase
    pkgs.kubectl
    pkgs.less
    pkgs.pinentry
    pkgs.ripgrep
    pkgs.silver-searcher
  ];
}
