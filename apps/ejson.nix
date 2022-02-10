{ pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.file."bin/decrypt-dotfiles".source = ../files/bin/decrypt-dotfiles;
    home.file.".config/ejson/secrets.ejson".source = ../files/secrets.ejson;

    home.packages = [ pkgs.ejson ];

    home.activation.decryptEJSONFiles = lib.hm.dag.entryAfter ["linkGeneration"] ''
      if [ -d ~/.config/ejson ]; then
        ${homeDir}/bin/decrypt-dotfiles
      fi
    '';
  };
}
