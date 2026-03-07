{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.pacman;
  isEnabled = elem "pacman" enabledModules;
in
{
  options.dotfiles.pacman = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
    };

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Packages to be installed";
      example = [
        docker
        ghostty
        keyd
      ];
    };
  };

  config = mkIf cfg.enable {
    # Create packages file
    home.file.".config/pacman/packages" = mkIf (cfg.packages != "") {
      text = strings.join "\n" cfg.packages;
    };

    # Install/update pacman packages
    home.activation.pacmanSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $VERBOSE_ECHO "Upgrading current packages..."

      cat ~/.config/pacman/packages | xargs /usr/bin/sudo pacman -Syu --noconfirm
      echo "✓ pacman installed packages"
    '';
  };
}
