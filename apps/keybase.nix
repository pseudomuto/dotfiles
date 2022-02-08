{ pkgs, lib, ...}:
let
  homeDir = builtins.getEnv "HOME";
in
{
  services = {
    keybase = {
      enable = true;
    };
  };

  activations = {
    # login to keybase using username and paper key from ejson secrets
    setupKeybase = lib.hm.dag.entryAfter ["writeBoundary"] ''
      set -euo pipefail

      main() {
        if ! keybase whoami >/dev/null; then
          local user=$(ejson decrypt ${homeDir}/.config/ejson/secrets.ejson | jq -r .keybase.username)
          local key=$(ejson decrypt ${homeDir}/.config/ejson/secrets.ejson | jq -r .keybase.paperKey)

          echo "$key" | keybase login --devicename "$(hostname)" $user
        fi
      }

      main "$@"
    '';

    importKeybaseKey = lib.hm.dag.entryAfter["setupKeybase"] ''
      set -euo pipefail

      main() {
        if ! gpg --with-colons --list-keys | grep ":6EA84352485608D0:" >/dev/null; then
          keybase pgp export | gpg --import
          keybase pgp export -s --unencrypted | gpg --allow-secret-key-import --import
        fi
      }

      main "$@"
    '';
  };
}
