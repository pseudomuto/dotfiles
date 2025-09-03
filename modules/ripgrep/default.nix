{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.ripgrep;
  isEnabled = elem "ripgrep" enabledModules;

  # Default ripgrep configuration
  defaultConfig = ''
    --glob=!.git/*
    --glob=!node_modules/*
    --glob=!vendor/*
    --hidden
    --max-columns=200
    --max-columns-preview
    --smart-case

    --type-add
    config:*.{yml,yaml,toml}
  '';
in
{
  options.dotfiles.ripgrep = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable ripgrep with custom configuration";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ripgrep;
      description = "The ripgrep package to use";
    };

    configFile = mkOption {
      type = types.lines;
      default = defaultConfig;
      description = "Contents of the ripgrep configuration file";
      example = ''
        --glob=!.git/*
        --hidden
        --smart-case
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional configuration to append to the ripgrep config file";
    };
  };

  config = mkIf cfg.enable {
    # Install ripgrep
    home.packages = [ cfg.package ];

    # Create ripgrep config file
    xdg.configFile."ripgrep/config".text = ''
      ${cfg.configFile}
      ${optionalString (cfg.extraConfig != "") cfg.extraConfig}
    '';

    # Set RIPGREP_CONFIG_PATH environment variable
    home.sessionVariables = {
      RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/config";
    };
  };
}
