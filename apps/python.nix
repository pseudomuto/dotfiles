{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      poetry
      python3
      python311Packages.pip
    ];
  };
}
