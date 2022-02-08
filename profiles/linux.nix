{ config, lib, pkgs, ... }:
with lib;
let
  default = import ../default.nix { pkgs=pkgs; lib=lib; };
  crdb = import ../apps/cockroachdb.nix { pkgs=pkgs; };
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

  # add common packages and any that are defined by apps
  home.packages = default.packages
    ++ builtins.concatLists (builtins.map (x: x.packages) (builtins.filter (x: x ? "packages") default.apps));

  # link common dotfiles and those defined by all apps
  home.file = mkMerge ([ default.files crdb.files ]
    ++ builtins.catAttrs "files" default.apps);

  # install/configure combined programs from all apps
  programs = mkMerge ([
    # Let Home Manager install and manage itself.
    { home-manager = { enable = true; }; }
  ] ++ builtins.catAttrs "programs" default.apps);

  # install/configure combined services from all apps
  services = mkMerge (builtins.catAttrs "services" default.apps);

  # attach any activations defined in apps
  home.activation = mkMerge (builtins.catAttrs "activations" default.apps);
}
