{ config, lib, pkgs, ... }:
with lib;
let
  git = import ../apps/git.nix { pkgs=pkgs; };
  go = import ../apps/go.nix { pkgs=pkgs; };
  gpg = import ../apps/gpg.nix { pkgs=pkgs; };
  nvim = import ../apps/nvim.nix { pkgs=pkgs; };
  tmux = import ../apps/tmux.nix { pkgs=pkgs; };
  shell = import ../apps/shell.nix { lib=lib; pkgs=pkgs; };
  apps = [git go gpg nvim tmux shell];
in
{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.packages = [
    pkgs.bazelisk
    pkgs.direnv
    pkgs.fasd
    pkgs.fzf
    pkgs.gcc
    pkgs.google-cloud-sdk
    pkgs.keybase
    pkgs.kubectl
    pkgs.pinentry
    pkgs.ripgrep
    pkgs.silver-searcher
  ];

  # link common dotfiles and those defined by all apps
  home.file = mkMerge ([
    {
      ".agignore".source = ../files/.agignore;
      ".gemrc".source = ../files/.gemrc;
      ".pryrc".source = ../files/.pryrc;
      "bin/docker-clean".source = ../files/bin/docker-clean;
    }
  ] ++ builtins.catAttrs "files" apps);

  # install/configure combined programs from all apps
  programs = mkMerge ([
    # Let Home Manager install and manage itself.
    { home-manager = { enable = true; }; }
  ] ++ builtins.catAttrs "programs" apps);

  # install/configure combined services from all apps
  services = mkMerge (builtins.catAttrs "services" apps);

  # attach any activations defined in apps
  home.activation = mkMerge (builtins.catAttrs "activations" apps);
}
