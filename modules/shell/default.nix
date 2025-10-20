{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.shell;
  isEnabled = elem "shell" enabledModules;

  # Auto-discover completion files
  completionFiles = builtins.filter (name: hasSuffix ".sh" name) (
    attrNames (builtins.readDir ./completions)
  );

  # Generate sourcing commands for completion files
  sourceCompletions = concatStringsSep "\n" (
    map (file: "source ${./completions}/${file}") completionFiles
  );

  # Common shell aliases
  commonAliases = {
    cat = "bat";
    cl = "clear";
    find = "fd";
    la = "eza -a";
    ll = "eza -la";
    ls = "eza";
  };

  # Platform-specific PATH additions
  darwinPathExtra = ''
    # macOS-specific PATH additions
    export PATH="$PATH:$HOME/.local/bin:/usr/local/bin"
    export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix libiconv)/lib"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$(brew --prefix libiconv)/lib"
  '';

  linuxPathExtra = ''
    # Linux-specific PATH additions
    export PATH="$HOME/.local/bin:$PATH"
  '';

  platformPathExtra = if pkgs.stdenv.isDarwin then darwinPathExtra else linuxPathExtra;
in
{
  options.dotfiles.shell = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable comprehensive shell configuration (zsh + bash)";
    };

    defaultShell = mkOption {
      type = types.enum [
        "zsh"
        "bash"
      ];
      default = "zsh";
      description = "Default shell to use";
    };

    enableCompletions = mkOption {
      type = types.bool;
      default = true;
      description = "Enable auto-loading of completion files from ./completions/";
    };

    extraAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Additional shell aliases";
      example = {
        grep = "rg";
        vim = "nvim";
      };
    };

    enableDirenv = mkOption {
      type = types.bool;
      default = true;
      description = "Enable direnv integration";
    };
  };

  config = mkIf cfg.enable {
    # Set default shell environment variable
    home.sessionVariables = {
      SHELL = "${if cfg.defaultShell == "zsh" then pkgs.zsh else pkgs.bash}/bin/${cfg.defaultShell}";
    };

    # Change the user's default shell using an activation script
    home.activation.setDefaultShell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ "${cfg.defaultShell}" == "zsh" ]]; then
        DESIRED_SHELL="${pkgs.zsh}/bin/zsh"
      else
        DESIRED_SHELL="${pkgs.bash}/bin/bash"
      fi
      PATH=/usr/bin:$PATH sudo chsh -s "$DESIRED_SHELL" "$(whoami)"
    '';

    # Zsh configuration
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = commonAliases // cfg.extraAliases;

      initContent = ''
        ${platformPathExtra}
        unsetopt nomatch

        ${optionalString cfg.enableCompletions ''
          # Auto-load completion files
          ${sourceCompletions}
        ''}

        # Initialize completion functions if they exist
        ${optionalString cfg.enableCompletions ''
          if declare -f kubectl-short-aliases >/dev/null; then
            kubectl-short-aliases
          fi
        ''}

        if [ -f ~/.config/dev/devrc ]; then source ~/.config/dev/devrc; fi
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "fasd"
          "git"
          "gitfast"
          "history-substring-search"
        ];
        theme = "robbyrussell";
      };

      defaultKeymap = "emacs";
    };

    # Bash configuration (fallback and compatibility)
    programs.bash = {
      enable = true;

      shellAliases = commonAliases // cfg.extraAliases;

      initExtra = ''
        ${platformPathExtra}

        ${optionalString cfg.enableCompletions ''
          # Auto-load completion files
          ${sourceCompletions}
        ''}

        # Initialize completion functions if they exist
        ${optionalString cfg.enableCompletions ''
          if declare -f kubectl-short-aliases >/dev/null; then
            kubectl-short-aliases
          fi
        ''}
      '';
    };

    # Direnv integration
    programs.direnv = mkIf cfg.enableDirenv {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    # Install shell-related packages
    home.packages =
      with pkgs;
      [
        # Install both shells for recent versions
        bash
        zsh

        # Required for aliases to work
        eza
        bat
        fd

        # Optional shell utilities
        fasd
        fzf
        jq
        tree
        uv
        yq
      ]
      ++ (map (
        scriptName:
        pkgs.writeShellApplication {
          name = scriptName;
          text = builtins.readFile (./scripts + "/${scriptName}");
        }
      ) (builtins.attrNames (builtins.readDir ./scripts)));
  };
}
