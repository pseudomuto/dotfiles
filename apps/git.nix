{ config, lib, pkgs, ...}:
{
  config = {
    home.file."bin/git-freeze".source = ../files/bin/git-freeze;
    home.file."bin/git-rebase-fork".source = ../files/bin/git-rebase-fork;
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
      aliases = {
        pr-get = "!f() { git fetch -fu \${2:-origin} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f";
        pr-clean = "!git checkout master; git for-each-ref refs/heads/pr/* --format=\"%(refname)\" | while read ref ; do branch=\${ref#refs/heads/} ; git branch -D $branch ; done";
      };
      ignores = [
        ".DS_Store"
        ".DS_Store?"
        ".claude"
        ".envrc"
        ".project"
        ".sdkmanrc"
        ".settings/"
        ".Spotlight-V100"
        ".Trashes"
        "._*"
        ".lvimrc"
        "CLAUDE.md"
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
        options = {
          line-numbers = true;
          side-by-side = true;
        };
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
