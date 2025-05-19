{ config, lib, pkgs, ... }:
{
  config = {
    home.file.".config/nix/nix.conf".source = ../files/nix.conf;
    home.file."bin/nix-upgrade".source = ../files/bin/nix-upgrade;
    home.file."bin/nr".source = ../files/bin/nr;
  };
}
