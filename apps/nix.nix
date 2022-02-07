{ pkgs, ... }:
{
  files = {
    ".config/nix/nix.conf" = { source = ../files/nix.conf; };
    "bin/nr" = { source = ../files/bin/nr; };
  };
}
