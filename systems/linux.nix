{
  pkgs,
  ...
}:

{
  # Define which modules this system should enable
  _module.args.enabledModules = [
    "dev"
    "git"
    "keybase"
    "kube-ps1"
    "nvim"
    "pacman"
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
    ncdu # disk usage
    tldr # simplified man pages
  ];
}
