{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.kube-ps1;
  isEnabled = elem "kube-ps1" enabledModules;

  # Fetch kube-ps1 from GitHub
  kube-ps1-src = pkgs.fetchFromGitHub {
    owner = "jonmosco";
    repo = "kube-ps1";
    rev = "f412a4bc807f733a18cdeca39eee906d82910302";
    sha256 = "sha256-Vy6OzQDlbdBwQ/eMjUhFekjdRk/ussXoCpK8A6Vwkw8=";
  };

  # Create a derivation that installs kube-ps1
  kube-ps1 = pkgs.stdenv.mkDerivation {
    pname = "kube-ps1";
    version = "0.8.0";
    src = kube-ps1-src;

    installPhase = ''
            mkdir -p $out/share/kube-ps1
            cp kube-ps1.sh $out/share/kube-ps1/

            mkdir -p $out/bin
            cat > $out/bin/kube-ps1 << EOF
      #!/bin/sh
      # Convenience script to source kube-ps1
      echo "Source this in your shell:"
      echo "  source $out/share/kube-ps1/kube-ps1.sh"
      echo "  PS1='[\\u@\\h \\W \\\$(kube_ps1)]\\$ '"
      EOF
            chmod +x $out/bin/kube-ps1
    '';

    meta = with lib; {
      description = "Kubernetes prompt info for bash and zsh";
      homepage = "https://github.com/jonmosco/kube-ps1";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = [ ];
    };
  };
in
{
  options.dotfiles.kube-ps1 = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable kube-ps1 Kubernetes prompt integration";
    };

    package = mkOption {
      type = types.package;
      default = kube-ps1;
      description = "The kube-ps1 package to use";
    };

    settings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Settings for kube-ps1. These will be exported as environment variables.

        Common settings include:
        - KUBE_PS1_PREFIX: Prefix for the prompt (default: "(")
        - KUBE_PS1_SUFFIX: Suffix for the prompt (default: ")")
        - KUBE_PS1_SEPARATOR: Separator between context and namespace (default: "|")
        - KUBE_PS1_SYMBOL_ENABLE: Enable/disable Kubernetes symbol (default: true)
        - KUBE_PS1_SYMBOL_DEFAULT: Default symbol (default: "☸️")
        - KUBE_PS1_SYMBOL_USE_IMG: Use Unicode symbol (default: false)
        - KUBE_PS1_NS_ENABLE: Enable/disable namespace display (default: true)
        - KUBE_PS1_CONTEXT_ENABLE: Enable/disable context display (default: true)
      '';
      example = {
        KUBE_PS1_PREFIX = "[";
        KUBE_PS1_SUFFIX = "]";
        KUBE_PS1_SYMBOL_ENABLE = "false";
        KUBE_PS1_NS_ENABLE = "true";
      };
    };

    enableZshIntegration = mkOption {
      type = types.bool;
      default = config.programs.zsh.enable;
      description = "Enable zsh integration";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = config.programs.bash.enable;
      description = "Enable bash integration";
    };
  };

  config = mkIf cfg.enable {
    # Install kube-ps1 package
    home.packages = [ cfg.package ];

    # Set environment variables for kube-ps1 settings
    home.sessionVariables = cfg.settings;

    # Zsh integration
    programs.zsh.initContent = mkIf cfg.enableZshIntegration ''
      # Load kube-ps1
      source ${cfg.package}/share/kube-ps1/kube-ps1.sh

      # Add kube-ps1 to right prompt (RPROMPT) to avoid interfering with existing prompt
      RPROMPT='$(kube_ps1)'
    '';

    # Bash integration
    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      # Load kube-ps1
      source ${cfg.package}/share/kube-ps1/kube-ps1.sh

      # Add kube-ps1 to PS1 (you may want to customize this)
      if [[ "$PS1" != *'$(kube_ps1)'* ]]; then
        PS1='[\u@\h \W $(kube_ps1)]\$ '
      fi
    '';
  };
}
