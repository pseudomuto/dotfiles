{ config, lib, pkgs, ... }:
{
  config = {
    programs.go = {
      enable = true;
      goBin = "bin";
      goPath = "";
      package = pkgs.go_1_18;
    };
  };
}
