{ pkgs, ... }:
{
  programs = {
    go = {
      enable = true;
      goBin = "bin";
      goPath = "";
    };
  };
}
