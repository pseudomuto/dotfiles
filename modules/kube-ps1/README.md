# kube-ps1 Module

This module provides [kube-ps1](https://github.com/jonmosco/kube-ps1) integration for displaying Kubernetes context and namespace information in your shell prompt.

## Options

### `programs.kube-ps1.enable`
- **Type**: boolean  
- **Default**: Enabled if "kube-ps1" is in enabledModules
- **Description**: Enable kube-ps1 Kubernetes prompt integration

### `programs.kube-ps1.package`
- **Type**: package
- **Default**: Custom kube-ps1 package built from GitHub
- **Description**: The kube-ps1 package to use

### `programs.kube-ps1.settings`
- **Type**: attribute set of strings
- **Default**: `{}`
- **Description**: Environment variables to configure kube-ps1 behavior

### `programs.kube-ps1.enableZshIntegration`
- **Type**: boolean
- **Default**: `config.programs.zsh.enable`
- **Description**: Enable zsh integration

### `programs.kube-ps1.enableBashIntegration`
- **Type**: boolean
- **Default**: `config.programs.bash.enable`
- **Description**: Enable bash integration

## Available Settings

Common kube-ps1 environment variables:

- `KUBE_PS1_PREFIX` - Prefix for the prompt (default: "(")
- `KUBE_PS1_SUFFIX` - Suffix for the prompt (default: ")")
- `KUBE_PS1_SEPARATOR` - Separator between context and namespace (default: "|")
- `KUBE_PS1_SYMBOL_ENABLE` - Enable/disable Kubernetes symbol (default: "true")
- `KUBE_PS1_SYMBOL_DEFAULT` - Default symbol (default: "☸️")
- `KUBE_PS1_SYMBOL_USE_IMG` - Use Unicode symbol (default: "false")
- `KUBE_PS1_NS_ENABLE` - Enable/disable namespace display (default: "true")
- `KUBE_PS1_CONTEXT_ENABLE` - Enable/disable context display (default: "true")

## Usage Examples

### Basic usage
```nix
{
  programs.kube-ps1.enable = true;
  # Uses default settings and integrates with your configured shells
}
```

### Custom settings
```nix
{
  programs.kube-ps1 = {
    enable = true;
    settings = {
      KUBE_PS1_PREFIX = "[";
      KUBE_PS1_SUFFIX = "]";
      KUBE_PS1_SEPARATOR = ":";
      KUBE_PS1_SYMBOL_ENABLE = "false";
      KUBE_PS1_NS_ENABLE = "true";
    };
  };
}
```

### Minimal display (context only)
```nix
{
  programs.kube-ps1 = {
    enable = true;
    settings = {
      KUBE_PS1_NS_ENABLE = "false";
      KUBE_PS1_SYMBOL_ENABLE = "false";
    };
  };
}
```

### Custom symbol
```nix
{
  programs.kube-ps1 = {
    enable = true;
    settings = {
      KUBE_PS1_SYMBOL_DEFAULT = "⎈";
      KUBE_PS1_SYMBOL_USE_IMG = "false";
    };
  };
}
```

## Shell Integration

### Zsh
The module automatically adds kube-ps1 to the right prompt (`RPROMPT`) to avoid interfering with your existing prompt setup.

### Bash
The module modifies `PS1` to include kube-ps1 output. The default format is:
```
[user@host dir (context|namespace)]$ 
```

## Manual Usage

If you prefer to configure the prompt manually, you can disable shell integration:

```nix
{
  programs.kube-ps1 = {
    enable = true;
    enableZshIntegration = false;
    enableBashIntegration = false;
  };
}
```

Then source kube-ps1 manually in your shell configuration:
```bash
source ~/.nix-profile/share/kube-ps1/kube-ps1.sh
PS1='[\u@\h \W $(kube_ps1)]\$ '
```

## Functions

After enabling kube-ps1, these functions become available:

- `kube_ps1` - Returns the current Kubernetes context/namespace string
- `kube_ps1_toggle` - Toggle kube-ps1 on/off
- `kube_ps1_symbol_toggle` - Toggle the Kubernetes symbol

## Requirements

- `kubectl` must be installed and configured
- A valid kubeconfig file (usually `~/.kube/config`)

## Platform Support

This module works on all platforms supported by Nix (Linux, macOS, etc.).