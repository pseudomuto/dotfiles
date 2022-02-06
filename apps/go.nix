{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  programs = {
    go = {
      enable = true;
      goBin = "bin";
      goPath = homeDir;
    };
  };
}
