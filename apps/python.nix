{ config, pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [
      pipenv
      poetry
      python3
      python312Packages.pip
      python312Packages.setuptools
    ];
  };
}
