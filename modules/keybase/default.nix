{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.keybase;
  isEnabled = elem "keybase" enabledModules;

  # Platform detection
  inherit (pkgs.stdenv) isDarwin;

  # Auto-select pinentry based on platform
  actualPinentryProgram =
    if cfg.gpg.pinentryProgram == "auto" then
      (if isDarwin then "mac" else "default")
    else
      cfg.gpg.pinentryProgram;

  pinentryPackage =
    if actualPinentryProgram == "mac" then
      pkgs.pinentry_mac
    else if actualPinentryProgram == "default" then
      pkgs.pinentry
    else if actualPinentryProgram == "curses" then
      pkgs.pinentry-curses
    else if actualPinentryProgram == "gtk2" then
      pkgs.pinentry-gtk2
    else if actualPinentryProgram == "qt" then
      pkgs.pinentry-qt
    else if actualPinentryProgram == "gnome3" then
      pkgs.pinentry-gnome3
    else
      pkgs.pinentry;
in
{
  options.dotfiles.keybase = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable Keybase and GPG encryption tools";
    };

    keybase = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Install Keybase";
      };
    };

    gpg = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable GPG configuration";
      };

      defaultKey = mkOption {
        type = types.nullOr types.str;
        default = "BB51C332DBB02953BE51F2E56EA84352485608D0";
        description = "Default GPG key ID";
        example = "0x1234567890ABCDEF";
      };

      pinentryProgram = mkOption {
        type = types.nullOr (
          types.enum [
            "default"
            "curses"
            "gtk2"
            "qt"
            "gnome3"
            "mac"
            "auto"
          ]
        );
        default = "auto";
        description = "Pinentry program to use for GPG (auto selects pinentry-mac on Darwin, pinentry on Linux)";
      };

      enableSshSupport = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GPG agent SSH support";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Keybase
      (mkIf cfg.keybase.enable keybase)

      # GPG and related tools
      (mkIf cfg.gpg.enable gnupg)
      (mkIf cfg.gpg.enable pinentryPackage)
    ];

    # GPG configuration
    programs.gpg = mkIf cfg.gpg.enable {
      enable = true;
      settings = mkMerge [
        {
          # Basic GPG settings
          keyserver = "hkps://hkps.pool.sks-keyservers.net";
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          cert-digest-algo = "SHA512";
          s2k-digest-algo = "SHA512";
          s2k-cipher-algo = "AES256";
          charset = "utf-8";
          fixed-list-mode = true;
          no-comments = true;
          no-emit-version = true;
          keyid-format = "0xlong";
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          with-fingerprint = true;
          require-cross-certification = true;
          no-symkey-cache = true;
          use-agent = true;
        }
        (mkIf (cfg.gpg.defaultKey != null) {
          default-key = cfg.gpg.defaultKey;
        })
      ];
    };

    # GPG Agent configuration
    services.gpg-agent = mkIf cfg.gpg.enable {
      enable = true;
      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;
      pinentry = {
        package = pinentryPackage;
      };
      inherit (cfg.gpg) enableSshSupport;
    };

    # Environment variables for Keybase
    home.sessionVariables = mkMerge [
      (mkIf cfg.keybase.enable {
        KEYBASE_ALLOW_ROOT = "1";
      })
      (mkIf (cfg.gpg.enable && cfg.gpg.enableSshSupport) {
        SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      })
    ];

    # Create GPG directories
    home.activation.createGpgDirs = mkIf cfg.gpg.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $VERBOSE_ECHO "Creating GPG directories..."
        mkdir -p ~/.gnupg
        chmod 700 ~/.gnupg
      ''
    );

    # Keybase service activation
    home.activation.keybaseSetup = mkIf cfg.keybase.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" "rejsonSecrets" ] ''
        PATH=~/.nix-profile/bin:$PATH

        main() {
          $VERBOSE_ECHO "Setting up Keybase..."
          # Create Keybase directories
          mkdir -p ~/.config/keybase

          # Only run if the private key is available
          if [ -f ~/.config/ejson/6f1d653196b2a9639631ddeb19d80f995873c18a0011666d8ee98e3d21ad1d0c ]; then
            if ! keybase whoami >/dev/null; then
              if [ -z "$DRY_RUN_CMD" ]; then
                local user=$(rejson decrypt lib/secrets.ejson | jq -r .keybase.username)
                local key=$(rejson decrypt lib/secrets.ejson | jq -r .keybase.paperKey)
                echo "$key" | keybase login --devicename "$(hostname -s)-$RANDOM" $user
              fi
            fi
          fi
        }

        main "$@"
      ''
    );
  };
}
