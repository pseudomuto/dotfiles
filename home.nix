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
  # SDKMAN Configuration
  dotfiles.sdkman = {
    enable = true;

    # Java versions to install
    candidates = [
      {
        name = "java";
        version = "24.0.2-amzn";
        default = true;
      }
      {
        name = "java";
        version = "21.0.8-amzn";
      }
      {
        name = "java";
        version = "17.0.16-amzn";
      }
    ];

    # SDKMAN configuration options
    config = {
      sdkman_auto_answer = "false";
      sdkman_selfupdate_feature = "true";
      sdkman_auto_env = "true";
      sdkman_colour_enable = "true";
      sdkman_auto_complete = "false";
    };
  };

  dotfiles.shell = {
    extraAliases = {
      dmux = "tmuxinator start dev";
      gl = "git log --date=short --pretty=format:'%Cgreen%h %Cblue%cd %Cred%an%Creset: %s'";
      grbf = "git rebase-fork";
      gsf = "git sync-fork";
      gup = "gpr && gfa";
    };
  };

  # Git Configuration (example)
  # dotfiles.git = {
  #   userName = "Your Name";
  #   userEmail = "your.email@example.com";
  # };

  # Development Tools Configuration (example)
  # dotfiles.dev = {
  #   languages = {
  #     go.enable = true;
  #     rust.enable = true;
  #     node.enable = true;
  #   };
  # };

  # Additional packages to install
  # home.packages = with pkgs; [
  #   # Add personal tools here
  # ];
}
