# Personal Home Manager Configuration
# This file contains user-specific settings and module configurations.
# It's automatically symlinked to ~/.config/home-manager/home.nix by the apply script.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  home.enableNixpkgsReleaseCheck = false;

  home.sessionVariables = {
    TERMINAL = "/usr/bin/ghostty";
  };

  home.file = {
    ".config/btop/btop.conf".source = ./static/btop.conf;
    # Will be manually (for now) symlinked to /etc/keyd/default.conf
    # Requires symlink and `sudo systemctl enable --now keyd`
    ".config/keyd/default.conf".source = ./static/keyd.conf;
    # Requires symlink to /etc/pacman.conf
    ".config/pacman/default.conf".source = ./static/pacman.conf;
  };

  home.packages = with pkgs; [
    _1password-cli
    bluetui
    btop
    docker-buildx
    docker-compose
    hostname-debian
    jq
    lazydocker
    less
    yq
  ];

  dotfiles.keybase = {
    gpg = {
      pinentryProgram = "gnome3";
    };
  };

  dotfiles.pacman = {
    packages = [
      "1password-beta"
      "chromium"
      "docker"
      "ghostty"
      "keyd"
    ];
  };

  dotfiles.shell = {
    extraAliases = {
      gl = "git log --date=short --pretty=format:'%Cgreen%h %Cblue%cd %Cred%an%Creset: %s'";
      grbf = "git rebase-fork";
      gsf = "git sync-fork";
      gup = "gpr && gfa";
    };
  };
}
