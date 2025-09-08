{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.git;
  isEnabled = elem "git" enabledModules;
in
{
  options.dotfiles.git = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable git with custom configuration";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.git;
      description = "The git package to use";
    };

    userName = mkOption {
      type = types.nullOr types.str;
      default = "David Muto (pseudomuto)";
      description = "Git user name";
      example = "John Doe";
    };

    userEmail = mkOption {
      type = types.nullOr types.str;
      default = "david.muto@gmail.com";
      description = "Git user email";
      example = "john.doe@example.com";
    };

    signingKey = mkOption {
      type = types.nullOr types.str;
      default = "6EA84352485608D0";
      description = "GPG key for signing commits";
    };

    signByDefault = mkOption {
      type = types.bool;
      default = true;
      description = "Sign commits by default";
    };

    defaultBranch = mkOption {
      type = types.str;
      default = "main";
      description = "Default branch name for new repositories";
    };

    editor = mkOption {
      type = types.str;
      default = "nvim";
      description = "Default editor for git";
    };

    delta = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable delta for better diffs";
      };

      options = mkOption {
        type = types.attrsOf types.anything;
        default = {
          navigate = true;
          light = false;
          side-by-side = true;
          line-numbers = true;
        };
        description = "Delta configuration options";
      };
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {
        pr-get = "!f() { git fetch -fu \${2:-origin} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f";
        pr-clean = "!git checkout master; git for-each-ref refs/heads/pr/* --format=\"%(refname)\" | while read ref ; do branch=\${ref#refs/heads/} ; git branch -D $branch ; done";
      };
      description = "Git command aliases";
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = { };
      description = "Additional git configuration";
      example = {
        merge.tool = "vimdiff";
        color.ui = "auto";
      };
    };

    ignores = mkOption {
      type = types.listOf types.str;
      default = [
        # OS generated files
        ".DS_Store"
        ".DS_Store?"
        "._*"
        ".Spotlight-V100"
        ".Trashes"
        "ehthumbs.db"
        "Icon"
        "Thumbs.db"

        # Editor files
        "*.swp"
        "*.swo"
        "*~"
        "*.orig"
        "*~"
        "\#*\#"
        ".idea/"
        ".vscode/"

        ".claude"
        "CLAUDE.md"

        # Language specific
        "__pycache__/"
        "*.pyc"
        "node_modules/"
        ".env"
        ".env.local"
        ".envrc"
        ".project"
        ".sdkmanrc"
        ".settings/"
        ".bundle"
        "vendor/bin"
        "vendor/bundle"
      ];
      description = "Global gitignore patterns";
    };
  };

  config = mkIf cfg.enable {
    # Install git and optional tools
    home.packages =
      with pkgs;
      [
        cfg.package
      ]
      ++ optional cfg.delta.enable delta;

    # Git configuration using Home Manager's git module
    programs.git = {
      enable = true;
      inherit (cfg) package;

      userName = mkIf (cfg.userName != null) cfg.userName;
      userEmail = mkIf (cfg.userEmail != null) cfg.userEmail;

      # Core configuration
      extraConfig = {
        init.defaultBranch = cfg.defaultBranch;
        core = {
          inherit (cfg) editor;
          autocrlf = "input";
          whitespace = "trailing-space,space-before-tab";
        };

        gc = {
          writeCommitGraph = true;
        };

        protocol = {
          version = 2;
        };

        push = {
          default = "current";
          autoSetupRemote = true;
        };

        pull = {
          rebase = true;
          ff = "only";
        };

        fetch = {
          prune = true;
          pruneTags = true;
        };

        diff = {
          colorMoved = "default";
          algorithm = "patience";
        };

        merge = {
          conflictstyle = "diff3";
        };

        pager = {
          branch = false;
        };

        rerere = {
          enabled = true;
        };

        rebase = {
          autoStash = true;
          autoSquash = true;
        };

        color = {
          ui = "auto";
          branch = "auto";
          diff = "auto";
          status = "auto";
        };

        help = {
          autocorrect = 10; # Auto-correct typos after 1 second
        };

        # Platform-specific settings
        credential = mkIf pkgs.stdenv.isDarwin {
          helper = "osxkeychain";
        };
      }
      // cfg.extraConfig;

      # Delta configuration
      delta = mkIf cfg.delta.enable {
        enable = true;
        inherit (cfg.delta) options;
      };

      # Aliases
      inherit (cfg) aliases;

      # Global ignore patterns
      inherit (cfg) ignores;

      # Commit signing
      signing = mkIf (cfg.signingKey != null) {
        key = cfg.signingKey;
        inherit (cfg) signByDefault;
      };
    };
  };
}
