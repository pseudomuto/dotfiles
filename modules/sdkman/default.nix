{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.sdkman;
  isEnabled = elem "sdkman" enabledModules;

  # Generate SDKMAN config file content
  configFileContent = concatStringsSep "\n" (
    mapAttrsToList (name: value: "${name}=${value}") cfg.config
  );

  # SDKMAN installation script
  installScript = pkgs.writeShellScript "install-sdkman" ''
    set -e

    export SDKMAN_DIR="''${SDKMAN_DIR:-$HOME/.sdkman}"

    # Skip if already installed
    if [ -d "$SDKMAN_DIR" ]; then
      echo "SDKMAN already installed at $SDKMAN_DIR"
      exit 0
    fi

    echo "Installing SDKMAN..."
    ${pkgs.curl}/bin/curl -s "https://get.sdkman.io" | ${pkgs.bash}/bin/bash

    echo "SDKMAN installation completed"
  '';

  # Script to configure SDKMAN
  configureScript = pkgs.writeShellScript "configure-sdkman" ''
    set -e

    export SDKMAN_DIR="''${SDKMAN_DIR:-$HOME/.sdkman}"

    # Create SDKMAN directory structure if it doesn't exist
    mkdir -p "$SDKMAN_DIR/etc"

    # Write config file
    echo "Writing SDKMAN configuration..."
    cat > "$SDKMAN_DIR/etc/config" << 'EOF'
    ${configFileContent}
    EOF

    echo "SDKMAN configuration completed"
  '';

  # Script to install candidates
  installCandidatesScript = pkgs.writeShellScript "install-sdkman-candidates" ''
    set -e

    export SDKMAN_DIR="''${SDKMAN_DIR:-$HOME/.sdkman}"

    # Check if SDKMAN is installed
    if [ ! -d "$SDKMAN_DIR" ]; then
      echo "SDKMAN not found at $SDKMAN_DIR, skipping candidate installation"
      exit 0
    fi

    # Source SDKMAN
    source "$SDKMAN_DIR/bin/sdkman-init.sh"

    # Install each candidate
    ${concatMapStringsSep "\n" (candidate: ''
      echo "Installing ${candidate.name} ${candidate.version}..."
      sdk install ${candidate.name} ${candidate.version} ${
        if candidate.default or false then "|| true" else "|| true"
      }
      ${optionalString (candidate.default or false) ''
        echo "Setting ${candidate.name} ${candidate.version} as default..."
        sdk default ${candidate.name} ${candidate.version} || true
      ''}
    '') cfg.candidates}

    echo "SDKMAN candidates installation completed"
  '';
in
{
  options.dotfiles.sdkman = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable SDKMAN! (Software Development Kit Manager)";
    };

    installOnActivation = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically install SDKMAN on Home Manager activation";
    };

    sdkmanDir = mkOption {
      type = types.str;
      default = "$HOME/.sdkman";
      description = "SDKMAN installation directory";
    };

    candidates = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = "The SDK candidate name (e.g., java, gradle, maven)";
            };
            version = mkOption {
              type = types.str;
              description = "The version to install (e.g., 21.0.5-amzn)";
            };
            default = mkOption {
              type = types.bool;
              default = false;
              description = "Whether to set this version as the default";
            };
          };
        }
      );
      default = [ ];
      description = "List of SDKMAN candidates to install";
      example = literalExpression ''
        [
          { name = "java"; version = "21.0.5-amzn"; default = true; }
          { name = "gradle"; version = "8.5"; }
          { name = "maven"; version = "3.9.6"; }
        ]
      '';
    };

    config = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "SDKMAN configuration options";
      example = literalExpression ''
        {
          sdkman_auto_answer = "false";
          sdkman_selfupdate_feature = "true";
          sdkman_auto_env = "true";
          sdkman_colour_enable = "true";
          sdkman_auto_complete = "true";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    # Ensure required dependencies are available
    home.packages = with pkgs; [
      curl
      unzip
      zip
    ];

    # Set SDKMAN_DIR environment variable
    home.sessionVariables = {
      SDKMAN_DIR = cfg.sdkmanDir;
    };

    # Install SDKMAN using Home Manager activation script
    home.activation.installSdkman = mkIf cfg.installOnActivation (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${installScript}
      ''
    );

    # Configure SDKMAN settings
    home.activation.configureSdkman = mkIf (cfg.config != { }) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD ${configureScript}
      ''
    );

    # Install SDKMAN candidates after SDKMAN installation
    home.activation.installSdkmanCandidates = mkIf (cfg.installOnActivation && cfg.candidates != [ ]) (
      lib.hm.dag.entryAfter [ "installSdkman" ] ''
        $DRY_RUN_CMD ${installCandidatesScript}
      ''
    );

    # Add SDKMAN initialization to shell profiles
    programs.bash.initExtra = mkIf config.programs.bash.enable ''
      # SDKMAN initialization
      export SDKMAN_DIR="''${SDKMAN_DIR:-$HOME/.sdkman}"
      [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    '';

    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      # SDKMAN initialization
      export SDKMAN_DIR="''${SDKMAN_DIR:-$HOME/.sdkman}"
      [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    '';
  };
}
