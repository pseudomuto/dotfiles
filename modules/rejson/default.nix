{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.rejson;
  isEnabled = elem "rejson" enabledModules;

  # Platform detection
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
  inherit (pkgs.stdenv) isAarch64;
  isX86_64 = pkgs.stdenv.isx86_64;

  # Determine platform string for download URL
  platformString =
    if isDarwin && isAarch64 then
      "darwin_arm64"
    else if isLinux && isAarch64 then
      "linux_arm64"
    else if isLinux && isX86_64 then
      "linux_amd64"
    else
      throw "Unsupported platform for rejson (only Darwin ARM64, Linux ARM64, and Linux AMD64 are supported)";

  # Platform hashes for v0.5.2
  platformHash =
    if isDarwin && isAarch64 then
      "sha256-PJNgXKF2Vpu8Nu68Tl3opPM0pmygJ0tr5AP79r+VozM="
    else if isLinux && isAarch64 then
      "sha256-eJ0HuBObH8XcHouECwnfWQMCmA99W4SZO0v3oBoGt7Q="
    else if isLinux && isX86_64 then
      "sha256-mwVZaL3RZM8YrgHDYkyUutMyKoUAt69RnG2mKSwGyDo="
    else
      throw "No hash defined for platform";

  rejson = pkgs.stdenv.mkDerivation rec {
    pname = "rejson";
    inherit (cfg) version;

    src = pkgs.fetchurl {
      url = "https://github.com/pseudomuto/rejson/releases/download/v${version}/rejson_${version}_${platformString}.tar.gz";
      hash = if cfg.overrideHash != null then cfg.overrideHash else platformHash;
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp rejson $out/bin/
      chmod +x $out/bin/rejson
      ln -sf $out/bin/rejson $out/bin/ejson

      runHook postInstall
    '';

    meta = with lib; {
      description = "A tool for working with eJSON files";
      homepage = "https://github.com/pseudomuto/rejson";
      platforms = platforms.unix;
    };
  };
in
{
  options.dotfiles.rejson = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable rejson JSON tool";
    };

    version = mkOption {
      type = types.str;
      default = "0.5.2";
      description = "Version of rejson to install";
    };

    overrideHash = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override the hash for the download (useful when hashes are not yet known)";
      example = "sha256-abc123...";
    };

    package = mkOption {
      type = types.package;
      default = rejson;
      description = "The rejson package to install";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      EJSON_KEYDIR = "${config.home.homeDirectory}/.config/ejson";
    };

    home.packages = [ cfg.package ];

    # Activation script to handle secrets decryption in user context
    home.activation.rejsonSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Check for secrets file in the dotfiles directory
      DOTFILES_DIR="${config.home.homeDirectory}/dotfiles"
      SECRETS_FILE="$DOTFILES_DIR/lib/secrets.ejson"

      if [ -f "$SECRETS_FILE" ]; then
        $VERBOSE_ECHO "Found $SECRETS_FILE, decrypting and extracting environment variables..."

        # Create directory for cached env vars
        mkdir -p ~/.config/rejson

        # Check if we have the private key
        if [ -f ~/.config/ejson/6f1d653196b2a9639631ddeb19d80f995873c18a0011666d8ee98e3d21ad1d0c ]; then
          # Create temporary file for decrypted JSON
          DECRYPTED_JSON=$(mktemp)
          trap "rm -f $DECRYPTED_JSON" EXIT

          # Change to dotfiles directory for decryption
          cd "$DOTFILES_DIR"

          # Decrypt the secrets (set EJSON_KEYDIR explicitly since sessionVariables aren't available in activation)
          export EJSON_KEYDIR="${config.home.homeDirectory}/.config/ejson"
          if ${cfg.package}/bin/rejson decrypt lib/secrets.ejson -o "$DECRYPTED_JSON"; then
            $VERBOSE_ECHO "Successfully decrypted secrets, extracting environment variables..."

            # Extract environment variables and write to cache file
            # Clear the cache file
            > ~/.config/rejson/env_vars.sh

            # Write each env var as an export statement
            ${pkgs.jq}/bin/jq -r '.env // {} | to_entries | .[] | "export \(.key)=\"\(.value)\""' "$DECRYPTED_JSON" >> ~/.config/rejson/env_vars.sh || true

            # Process files from the secrets
            ${pkgs.jq}/bin/jq -r '.files // {} | to_entries | .[] | "\(.key)|\(.value)"' "$DECRYPTED_JSON" 2>/dev/null | while IFS='|' read -r filepath content; do
              if [ -n "$filepath" ] && [ -n "$content" ]; then
                mkdir -p "${config.home.homeDirectory}/$(dirname "$filepath")"
                echo "$content" >"${config.home.homeDirectory}/$filepath"
                $VERBOSE_ECHO "Created file: ${config.home.homeDirectory}/$filepath"
              fi
            done || true

            $VERBOSE_ECHO "Environment variables cached to ~/.config/rejson/env_vars.sh"
          else
            $VERBOSE_ECHO "Failed to decrypt secrets"
          fi

          rm -f "$DECRYPTED_JSON"
        else
          $VERBOSE_ECHO "EJSON private key not found"
        fi
      else
        $VERBOSE_ECHO "Secrets file not found at $SECRETS_FILE"
      fi
    '';

    # Source the cached environment variables in shells
    programs.bash.initExtra = mkIf config.programs.bash.enable ''
      # Load cached rejson environment variables
      if [ -f ~/.config/rejson/env_vars.sh ]; then
        source ~/.config/rejson/env_vars.sh
      fi
    '';

    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      # Load cached rejson environment variables
      if [ -f ~/.config/rejson/env_vars.sh ]; then
        source ~/.config/rejson/env_vars.sh
      fi
    '';
  };
}
