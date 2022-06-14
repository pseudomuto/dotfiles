{ config, lib, pkgs, isLinux, ...}:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.packages = lib.mkIf isLinux [ pkgs.keybase ];

    services.keybase = lib.mkIf isLinux {
      enable = true;
    };

    # login to keybase using username and paper key from ejson secrets
    home.activation.setupKeybase = lib.hm.dag.entryAfter ["installPackages"] ''
      set -euo pipefail

      main() {
        if ! keybase whoami >/dev/null; then
          if [ -z "$DRY_RUN_CMD" ]; then
            local user=$(ejson decrypt ${homeDir}/.config/ejson/secrets.ejson | jq -r .keybase.username)
            local key=$(ejson decrypt ${homeDir}/.config/ejson/secrets.ejson | jq -r .keybase.paperKey)
            echo "$key" | keybase login --devicename "$(hostname)-$RANDOM" $user
          fi
        fi
      }

      main "$@"
    '';

    home.activation.importKeybaseKey = lib.hm.dag.entryAfter["setupKeybase"] ''
      set -euo pipefail

      main() {
        if ! gpg --with-colons --list-keys | grep ":6EA84352485608D0:" >/dev/null; then
          $DRY_RUN_CMD keybase pgp export | gpg --import
          $DRY_RUN_CMD keybase pgp export -s --unencrypted | gpg --allow-secret-key-import --import
        fi
      }

      main "$@"
    '';
  };
}
