{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.homebrew;
  isEnabled = elem "homebrew" enabledModules;
  inherit (pkgs.stdenv) isDarwin;
in
{
  options.dotfiles.homebrew = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled && isDarwin;
      description = "Enable Homebrew and Brewfile management (macOS only)";
    };

    brewfilePath = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.config/homebrew/Brewfile";
      description = "Path to the Brewfile";
    };

    autoUpdate = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically update Homebrew on activation";
    };

    autoUpgrade = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically upgrade all packages on activation";
    };

    brewfile = mkOption {
      type = types.lines;
      default = ''
        cask "1password"
        cask "1password-cli"
        cask "alfred"
        cask "anylist"
        cask "bartender"
        cask "beeper"
        cask "cleanshot"
        cask "db-browser-for-sqlite"
        cask "docker-desktop"
        cask "dropbox"
        cask "google-chrome"
        cask "iterm2"
        cask "keybase"
        cask "linear-linear"
        cask "notion"
        cask "rectangle"
        cask "slack"

        brew "libiconv"
      '';
      description = "Contents of the Brewfile";
      example = ''
        # Taps
        tap "homebrew/cask"
        tap "homebrew/cask-fonts"

        # Casks
        cask "1password"
        cask "alfred"
        cask "docker"
        cask "firefox"

        # Fonts
        cask "font-fira-code-nerd-font"
      '';
    };

    extraBrews = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional brew packages to install";
      example = [
        "jq"
        "curl"
        "wget"
      ];
    };

    extraCasks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional cask packages to install";
      example = [
        "visual-studio-code"
        "slack"
        "zoom"
      ];
    };

    extraTaps = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional taps to add";
      example = [ "homebrew/cask-versions" ];
    };
  };

  config = mkIf (cfg.enable && isDarwin) {
    # Create Brewfile
    home.file.".config/homebrew/Brewfile" = mkIf (cfg.brewfile != "") {
      text =
        cfg.brewfile
        + optionalString (cfg.extraTaps != [ ] || cfg.extraBrews != [ ] || cfg.extraCasks != [ ]) ''

          # Additional packages from module configuration
          ${concatMapStringsSep "\n" (tap: ''tap "${tap}"'') cfg.extraTaps}
          ${concatMapStringsSep "\n" (brew: ''brew "${brew}"'') cfg.extraBrews}
          ${concatMapStringsSep "\n" (cask: ''cask "${cask}"'') cfg.extraCasks}
        '';
    };

    # Install Homebrew if not present and run bundle
    home.activation.homebrewSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $VERBOSE_ECHO "Setting up Homebrew..."
      PATH="~/.nix-profile/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

      # Check if we're on macOS
      if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "Warning: Homebrew module is only supported on macOS"
        exit 0
      fi

      # Install Homebrew if not present
      if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        if [ -z "$DRY_RUN_CMD" ]; then
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

          # Add Homebrew to PATH for current session
          if [[ $(uname -m) == "arm64" ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
          else
            export PATH="/usr/local/bin:$PATH"
          fi
        else
          echo "DRY RUN: Would install Homebrew"
        fi
      else
        echo "Homebrew already installed"

        # Ensure Homebrew is in PATH
        if [[ $(uname -m) == "arm64" ]]; then
          export PATH="/opt/homebrew/bin:$PATH"
        else
          export PATH="/usr/local/bin:$PATH"
        fi
      fi

      # Update Homebrew if requested
      ${optionalString cfg.autoUpdate ''
        if command -v brew >/dev/null 2>&1; then
          echo "Updating Homebrew..."
          if [ -z "$DRY_RUN_CMD" ]; then
            brew update
          else
            echo "DRY RUN: Would run 'brew update'"
          fi
        fi
      ''}

      # Upgrade packages if requested
      ${optionalString cfg.autoUpgrade ''
        if command -v brew >/dev/null 2>&1; then
          echo "Upgrading Homebrew packages..."
          if [ -z "$DRY_RUN_CMD" ]; then
            brew upgrade
          else
            echo "DRY RUN: Would run 'brew upgrade'"
          fi
        fi
      ''}

      # Install packages from Brewfile if it exists
      if [ -f "${cfg.brewfilePath}" ] && command -v brew >/dev/null 2>&1; then
        echo "Installing packages from Brewfile..."
        if [ -z "$DRY_RUN_CMD" ]; then
          brew bundle install --file="${cfg.brewfilePath}"
        else
          echo "DRY RUN: Would run 'brew bundle install --file=${cfg.brewfilePath}'"
        fi
      elif [ -f "${cfg.brewfilePath}" ]; then
        echo "Warning: Brewfile found but Homebrew not available"
      else
        echo "No Brewfile found at ${cfg.brewfilePath}"
      fi

      echo "✓ Homebrew setup complete"
    '';

    # Add Homebrew to shell PATH
    home.sessionVariables = {
      # Set Homebrew path based on architecture
      HOMEBREW_PREFIX = if pkgs.stdenv.isAarch64 then "/opt/homebrew" else "/usr/local";
    };

    # Add Homebrew bin to PATH in shell profiles
    programs.zsh = mkIf config.programs.zsh.enable {
      initContent = ''
        # Add Homebrew to PATH
        if [[ -d "/opt/homebrew/bin" ]]; then
          export PATH="/opt/homebrew/bin:$PATH"
        elif [[ -d "/usr/local/bin" ]]; then
          export PATH="/usr/local/bin:$PATH"
        fi
      '';
    };

    programs.bash = mkIf config.programs.bash.enable {
      initExtra = ''
        # Add Homebrew to PATH
        if [[ -d "/opt/homebrew/bin" ]]; then
          export PATH="/opt/homebrew/bin:$PATH"
        elif [[ -d "/usr/local/bin" ]]; then
          export PATH="/usr/local/bin:$PATH"
        fi
      '';
    };
  };
}
