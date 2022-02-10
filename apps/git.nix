{ config, lib, pkgs, ...}:
{
  config = {
    home.file."bin/git-freeze".source = ../files/bin/git-freeze;
    home.file."bin/git-sync-fork".source = ../files/bin/git-sync-fork;
    home.file."bin/git-thaw".source = ../files/bin/git-thaw;

    programs.git = {
      enable = true;
      userName = "David Muto (pseudomuto)";
      userEmail = "david.muto@gmail.com";
      signing = {
        key = "6EA84352485608D0";
        signByDefault = true;
      };
      ignores = [
        ".envrc"
        ".DS_Store"
        ".DS_Store?"
        ".Spotlight-V100"
        ".Trashes"
        "._*"
        ".lvimrc"
        "Icon"
        "Thumbs.db"
        "*.swp"
        "*.swo"
        "*.orig"
        "*~"
        "\#*\#"
        "tags"
        ".bundle"
        "vendor/bin"
        "vendor/bundle"
      ];
      delta = {
        enable = true;
      };
      extraConfig = {
        color = {
          ui = true;
        };
        core = {
          commitGraph = true;
          editor = "vim";
        };
        credential = {
          helper = "store";
        };
        diff = {
          algorithm = "patience";
        };
        gc = {
          writeCommitGraph = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        pager = {
          branch = false;
        };
        protocol = {
          version = 2;
        };
        pull = {
          rebase = true;
        };
        push = {
          default = "simple";
        };
      };
    };
  };
}
