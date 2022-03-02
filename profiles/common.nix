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
    home.file."bin/docker-clean".source = ../files/bin/docker-clean;

    home.packages = with pkgs; [
      bazelisk
      direnv
      fasd
      fzf
      docker-compose
      gcc
      google-cloud-sdk
      jq
      k9s
      kubectl
      less
      pinentry
      ripgrep
      silver-searcher
      tree
      unzip
    ];

    programs.home-manager = { enable = true; };
  };
}
