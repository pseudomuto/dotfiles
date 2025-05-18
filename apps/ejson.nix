{ pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.file."bin/decrypt-dotfiles".source = ../files/bin/decrypt-dotfiles;
    home.file.".config/ejson/secrets.ejson".source = ../files/secrets.ejson;

    # Assuming ejson is installed.
    #home.packages = [ pkgs.ejson ];

    home.activation.decryptEJSONFiles = lib.hm.dag.entryAfter ["runTasks"] ''
      if [ -d ~/.config/ejson ]; then
        $DRY_RUN_CMD ${homeDir}/bin/decrypt-dotfiles
      fi
    '';
  };
}
