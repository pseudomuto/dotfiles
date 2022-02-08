{ pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  files = {
    "bin/decrypt-dotfiles" = { source = ../files/bin/decrypt-dotfiles; };
    ".config/ejson/secrets.ejson" = { source = ../files/secrets.ejson; };
  };

  packages = [
    pkgs.ejson
  ];

  activations = {
    decryptEJSONFiles = lib.hm.dag.entryAfter ["linkGeneration"] ''
      if [ -d ~/.config/ejson ]; then
        ${homeDir}/bin/decrypt-dotfiles
      fi
    '';
  };
}
