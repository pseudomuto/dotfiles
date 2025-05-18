{ pkgs, lib, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.file.".config/taskfile.yaml".source = ../files/taskfile.yaml;
    home.packages = [ pkgs.go-task ];

    home.activation.runTasks = lib.hm.dag.entryAfter ["installPackages"] ''
      $DRY_RUN_CMD task -d ${homeDir}/.config
    '';
  };
}

