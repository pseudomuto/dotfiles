{
  pkgs,
  ...
}:

{
  # Define which modules this system should enable
  _module.args.enabledModules = [
    "dev"
    "gcloud"
    "git"
    "keybase"
    "kube-ps1"
    "nvim"
    "rejson"
    "ripgrep"
    "shell"
    "tmux"
  ];

  # Core packages for Linux environment
  home.packages = with pkgs; [
    # System utilities
    curl
    wget
    htop

    # Data tools
    yq # YAML processor

    # Terminal tools
    ncdu # disk usage
    tldr # simplified man pages
  ];
}
