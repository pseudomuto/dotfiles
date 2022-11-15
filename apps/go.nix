{ config, lib, pkgs, ... }:
{
  config = {
    programs.go = {
      enable = true;
      goBin = "bin";
      goPath = "";
    };
  };
}
