{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.gcloud;
  isEnabled = elem "gcloud" enabledModules;

  # Google Cloud SDK with configurable extra components
  gcloudWithComponents = pkgs.google-cloud-sdk.withExtraComponents (
    # Filter out invalid component names and map to actual components
    builtins.filter (comp: comp != null) (
      map (
        name:
        if builtins.hasAttr name pkgs.google-cloud-sdk.components then
          pkgs.google-cloud-sdk.components.${name}
        else
          (builtins.trace "Warning: gcloud component '${name}' not found, skipping" null)
      ) cfg.extraComponents
    )
  );
in
{
  options.dotfiles.gcloud = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable Google Cloud SDK with extra components";
    };

    package = mkOption {
      type = types.package;
      default = gcloudWithComponents;
      description = "The Google Cloud SDK package to use";
    };

    extraComponents = mkOption {
      type = types.listOf types.str;
      default = [
        "gke-gcloud-auth-plugin"
        "config-connector"
        "pubsub-emulator"
      ];
      description = ''
        List of gcloud components to install.

        Available components include:
        - gke-gcloud-auth-plugin: GKE authentication plugin
        - config-connector: Config Connector for Kubernetes
        - pubsub-emulator: Pub/Sub emulator for local development
        - bigtable-emulator: Bigtable emulator for local development
        - datastore-emulator: Datastore emulator for local development
        - firestore-emulator: Firestore emulator for local development
        - gcd-emulator: Cloud Datastore emulator (legacy)
        - kubectl: Kubernetes command-line tool
        - docker-credential-gcr: Docker credential helper for GCR
        - alpha: Alpha commands
        - beta: Beta commands

        To see all available components, run: gcloud components list --show-versions
      '';
      example = [
        "gke-gcloud-auth-plugin"
        "kubectl"
        "alpha"
        "beta"
      ];
    };
  };

  config = mkIf cfg.enable {
    # Install gcloud package
    home.packages = [ cfg.package ];

    # Environment variables
    home.sessionVariables = {
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    };

    # Create gcloud config directory
    home.file.".config/gcloud/.keep".text = "";

    # Shell initialization for gcloud
    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      # Disable automatic updates and usage reporting
      export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true
      export CLOUDSDK_COMPONENT_MANAGER_DISABLE_UPDATE_CHECK=true
    '';

    programs.bash.initExtra = mkIf config.programs.bash.enable ''
      # Disable automatic updates and usage reporting
      export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true
      export CLOUDSDK_COMPONENT_MANAGER_DISABLE_UPDATE_CHECK=true
    '';
  };
}
