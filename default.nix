{ pkgs, lib, ...}:
let
  ejson = import apps/ejson.nix { pkgs=pkgs; lib=lib; };
  git = import apps/git.nix { pkgs=pkgs; };
  go = import apps/go.nix { pkgs=pkgs; };
  gpg = import apps/gpg.nix { pkgs=pkgs; };
  keybase = import apps/keybase.nix { pkgs=pkgs; lib=lib; };
  nix = import apps/nix.nix { pkgs=pkgs; };
  nvim = import apps/nvim.nix { pkgs=pkgs; };
  tmux = import apps/tmux.nix { pkgs=pkgs; };
  shell = import apps/shell.nix { lib=lib; pkgs=pkgs; };
in
{
  apps = [
    ejson
    git
    go
    gpg
    keybase
    nix
    nvim
    tmux
    shell
  ];

  files = {
    ".agignore" = { source = files/.agignore; };
    ".gemrc" = { source = files/.gemrc; };
    ".pryrc" = { source = files/.pryrc; };
    ".config/ripgrep/config" = { source = files/.ripgreprc; };
    "bin/docker-clean" = { source = files/bin/docker-clean; };
  };

  packages = [
    pkgs.bazelisk
    pkgs.direnv
    pkgs.fasd
    pkgs.fzf
    pkgs.gcc
    pkgs.google-cloud-sdk
    pkgs.jq
    pkgs.kubectl
    pkgs.less
    pkgs.pinentry
    pkgs.ripgrep
    pkgs.silver-searcher
  ];
}
