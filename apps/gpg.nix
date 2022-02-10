{ config, lib, pkgs, ... }:
{
  config = {
    programs.gpg = {
      enable = true;
      settings = {
        default-key = "BB51C332DBB02953BE51F2E56EA84352485608D0";
        keyserver = "hkps://hkps.pool.sks-keyservers.net";
      };
    };

    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
  };
}
