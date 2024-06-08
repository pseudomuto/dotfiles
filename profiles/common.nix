{ lib, pkgs, ...}:
{
  config = {
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

    home.file.".agignore".source = ../files/.agignore;
    home.file.".gemrc".source = ../files/.gemrc;
    home.file.".pryrc".source = ../files/.pryrc;
    home.file.".config/ripgrep/config".source = ../files/.ripgreprc;
    home.file."bin/bazel".source = ../files/bin/bazel;
    home.file."bin/docker-clean".source = ../files/bin/docker-clean;
    home.file."bin/nix-upgrade".source = ../files/bin/nix-upgrade;

    # https://github.com/NixOS/nixpkgs/issues/196651
    manual.manpages.enable = false;

    # create "gcloud" package which adds some extra components to
    # google-cloud-sdk.
    nixpkgs.overlays = with pkgs.google-cloud-sdk.components; [
      (self: super: {
         gcloud = super.google-cloud-sdk.withExtraComponents([
           alpha
           beta
           config-connector
           gke-gcloud-auth-plugin
           pubsub-emulator
         ]);
      })
    ];


    home.packages = with pkgs; [
      awscli2
      bash
      bazelisk
      direnv
      fasd
      fd
      foreman
      fzf
      docker-compose
      gcloud
      gnumake
      go-task
      gradle
      jq
      k9s
      kubectl
      less
      nodenv
      ripgrep
      tree
      unzip
      wget
    ];

    programs.home-manager = { enable = true; };
  };
}
