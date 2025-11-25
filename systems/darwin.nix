{
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  # Define which modules this system should enable
  _module.args.enabledModules = [
    "dev"
    "gcloud"
    "git"
    "homebrew"
    "keybase"
    "kube-ps1"
    "nvim"
    "rejson"
    "ripgrep"
    "sdkman"
    "shell"
    "tmux"
  ];

  # Core packages for Darwin environment
  home.packages = with pkgs; [
    # System utilities (macOS-specific versions)
    coreutils
    findutils
    gnugrep
    gnused
    gnutar
    gawk
    xz

    # Essential tools
    curl
    wget

    # Terminal tools
    ncdu # disk usage
    tldr # simplified man pages
    htop
  ];
}
