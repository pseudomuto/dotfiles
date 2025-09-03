{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.dev;
  isEnabled = elem "dev" enabledModules;
in
{
  options.dotfiles.dev = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable development tools and environments";
    };

    go = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install Go programming language";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.go;
        description = "The Go package to use";
      };

      goPath = mkOption {
        type = types.str;
        default = "$HOME";
        description = "GOPATH environment variable";
      };
    };

    rust = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install Rust programming language via rustup";
      };

      defaultToolchain = mkOption {
        type = types.str;
        default = "stable";
        description = "Default Rust toolchain (stable, beta, nightly)";
      };

      components = mkOption {
        type = types.listOf types.str;
        default = [
          "rustc"
          "cargo"
          "rustfmt"
          "clippy"
        ];
        description = "Rust components to install";
      };
    };

    node = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install Node.js";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.nodejs;
        description = "The Node.js package to use";
      };

      enableYarn = mkOption {
        type = types.bool;
        default = true;
        description = "Install Yarn package manager";
      };

      enablePnpm = mkOption {
        type = types.bool;
        default = false;
        description = "Install pnpm package manager";
      };
    };

    python = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install Python development environment";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.python3;
        description = "The Python package to use";
      };

      enablePipenv = mkOption {
        type = types.bool;
        default = false;
        description = "Install pipenv for virtual environments";
      };

      enablePoetry = mkOption {
        type = types.bool;
        default = true;
        description = "Install poetry for dependency management";
      };
    };

    docker = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Install Docker and related tools";
      };

      enableCompose = mkOption {
        type = types.bool;
        default = true;
        description = "Install Docker Compose";
      };
    };

    terraform = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Install Terraform";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.terraform;
        description = "The Terraform package to use";
      };
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional development packages to install";
      example = literalExpression "[ pkgs.jq pkgs.curl pkgs.wget ]";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        # Go
        (mkIf cfg.go.enable cfg.go.package)

        # Rust (using rustup for toolchain management)
        (mkIf cfg.rust.enable rustup)

        # Node.js and package managers
        (mkIf cfg.node.enable cfg.node.package)
        (mkIf (cfg.node.enable && cfg.node.enableYarn) yarn)
        (mkIf (cfg.node.enable && cfg.node.enablePnpm) nodePackages.pnpm)

        # Python
        (mkIf cfg.python.enable cfg.python.package)
        (mkIf (cfg.python.enable && cfg.python.enablePipenv) pipenv)
        (mkIf (cfg.python.enable && cfg.python.enablePoetry) poetry)

        # Docker
        (mkIf cfg.docker.enable docker)
        (mkIf (cfg.docker.enable && cfg.docker.enableCompose) docker-compose)

        # Terraform
        (mkIf cfg.terraform.enable cfg.terraform.package)

        # Common development tools
        claude-code
        go-task
        unzip
        zip

        # Version control helpers
        gh # GitHub CLI
        git-lfs
        lazygit
      ]
      ++ cfg.extraPackages;

    # Environment variables
    home.sessionVariables = mkMerge [
      (mkIf cfg.go.enable {
        GOPATH = cfg.go.goPath;
        PATH = "$PATH:${cfg.go.goPath}/bin";
      })
    ];

    # Rust setup via rustup
    home.activation.rustupSetup = mkIf cfg.rust.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATH=${lib.makeBinPath [ pkgs.rustup ]}''${PATH:+:}$PATH
        if command -v rustup >/dev/null 2>&1; then
          $VERBOSE_ECHO "Setting up Rust toolchain..."

          # Install default toolchain
          $VERBOSE_ECHO "Installing Rust ${cfg.rust.defaultToolchain} toolchain..."
          rustup toolchain install ${cfg.rust.defaultToolchain}

          # Set default toolchain
          rustup default ${cfg.rust.defaultToolchain}

          # Install components
          ${concatMapStringsSep "\n" (component: ''
            $VERBOSE_ECHO "Installing Rust component: ${component}"
            rustup component add ${component} --toolchain ${cfg.rust.defaultToolchain}
          '') cfg.rust.components}
        else
          echo "Warning: rustup not found in PATH, skipping Rust toolchain setup"
        fi
      ''
    );

    # Create common development directories
    home.activation.createDevDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $VERBOSE_ECHO "Creating development directories..."
      mkdir -p "$HOME/dev"
      mkdir -p "$HOME/bin"
      ${optionalString cfg.go.enable ''mkdir -p "${cfg.go.goPath}/src" "${cfg.go.goPath}/bin" "${cfg.go.goPath}/pkg"''}
    '';
  };
}
