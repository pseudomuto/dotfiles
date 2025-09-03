# Google Cloud SDK Module

This module provides Google Cloud SDK installation with configurable components.

## Options

### `programs.gcloud.enable`
- **Type**: boolean  
- **Default**: Enabled if "gcloud" is in enabledModules
- **Description**: Enable Google Cloud SDK

### `programs.gcloud.package`
- **Type**: package
- **Default**: Google Cloud SDK with configured extra components
- **Description**: The Google Cloud SDK package to use

### `programs.gcloud.extraComponents`
- **Type**: list of strings
- **Default**: `[ "gke-gcloud-auth-plugin" "config-connector" "pubsub-emulator" ]`
- **Description**: List of gcloud components to install

## Available Components

Common components include:
- `gke-gcloud-auth-plugin` - GKE authentication plugin (required for modern GKE)
- `kubectl` - Kubernetes command-line tool
- `config-connector` - Config Connector for Kubernetes
- `pubsub-emulator` - Pub/Sub emulator for local development
- `bigtable-emulator` - Bigtable emulator
- `datastore-emulator` - Datastore emulator
- `firestore-emulator` - Firestore emulator
- `docker-credential-gcr` - Docker credential helper for GCR
- `alpha` - Alpha commands
- `beta` - Beta commands

To see all available components:
```bash
nix-shell -p google-cloud-sdk --run "gcloud components list --show-versions"
```

## Usage Examples

### Basic usage (use defaults)
In your Home Manager configuration:
```nix
{
  programs.gcloud.enable = true;
  # Uses default components: gke-gcloud-auth-plugin, config-connector, pubsub-emulator
}
```

### Custom components
```nix
{
  programs.gcloud = {
    enable = true;
    extraComponents = [
      "gke-gcloud-auth-plugin"  # Required for GKE
      "kubectl"                 # Kubernetes CLI
      "alpha"                   # Alpha commands
      "beta"                    # Beta commands
      "docker-credential-gcr"   # Docker credential helper
    ];
  };
}
```

### Minimal installation (just core gcloud)
```nix
{
  programs.gcloud = {
    enable = true;
    extraComponents = [ ];  # No extra components
  };
}
```

### Development setup with emulators
```nix
{
  programs.gcloud = {
    enable = true;
    extraComponents = [
      "gke-gcloud-auth-plugin"
      "pubsub-emulator"
      "datastore-emulator"
      "firestore-emulator"
      "bigtable-emulator"
    ];
  };
}
```

### Using with custom package
```nix
{
  programs.gcloud = {
    enable = true;
    package = pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
      pkgs.google-cloud-sdk.components.kubectl
    ];
  };
}
```

## Platform-specific Configuration

You can configure different components per platform in your `flake.nix`:

```nix
# In your Home Manager modules
{
  programs.gcloud = {
    enable = true;
    extraComponents = if pkgs.stdenv.isDarwin then [
      # macOS-specific components
      "gke-gcloud-auth-plugin"
      "kubectl"
      "docker-credential-gcr"
    ] else [
      # Linux-specific components  
      "gke-gcloud-auth-plugin"
      "pubsub-emulator"
      "datastore-emulator"
    ];
  };
}
```

## Environment Variables

The module automatically sets:
- `USE_GKE_GCLOUD_AUTH_PLUGIN=True` - Enables GKE auth plugin
- `CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true` - Disables usage reporting
- `CLOUDSDK_COMPONENT_MANAGER_DISABLE_UPDATE_CHECK=true` - Disables update checks

## Configuration Directory

The module creates `~/.config/gcloud/` directory for gcloud configuration files.