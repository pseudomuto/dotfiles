# Shell Module

This module provides comprehensive shell configuration for both Zsh and Bash, with automatic completion loading, direnv integration, and platform-specific optimizations.

## Features

- **Dual shell support**: Configures both Zsh (default) and Bash
- **Auto-completion loading**: Automatically sources all `.sh` files from `./completions/`
- **Platform-aware PATH management**: Different PATH setups for Darwin vs Linux
- **Modern shell tools**: Integrates with direnv
- **Consistent aliases**: Common aliases across both shells
- **Extensible**: Easy to add new completions and customize

## Options

### `programs.shell.enable`
- **Type**: boolean
- **Default**: Enabled if "shell" is in enabledModules
- **Description**: Enable comprehensive shell configuration

### `programs.shell.defaultShell`
- **Type**: enum ["zsh", "bash"]
- **Default**: "zsh"
- **Description**: Default shell to use

### `programs.shell.enableCompletions`
- **Type**: boolean
- **Default**: true
- **Description**: Enable auto-loading of completion files from ./completions/

### `programs.shell.extraAliases`
- **Type**: attribute set of strings
- **Default**: `{}`
- **Description**: Additional shell aliases

### `programs.shell.enableDirenv`
- **Type**: boolean
- **Default**: true
- **Description**: Enable direnv integration

## Default Configuration

### Shell Aliases
The module provides these common aliases:
```bash
ll = "eza -la"     # Long listing with all files
la = "eza -a"      # All files
ls = "eza"         # Modern ls replacement
cat = "bat"        # Syntax-highlighted cat
find = "fd"        # Modern find replacement
```

### Installed Packages
The module automatically installs:
- `eza` - Modern ls replacement
- `bat` - Syntax-highlighted cat
- `fd` - Modern find replacement  
- `ripgrep` - Fast grep replacement
- `fzf` - Fuzzy finder
- `jq` - JSON processor
- `tree` - Directory tree viewer

### Platform-Specific PATH

**Darwin (macOS)**:
```bash
export PATH="/usr/local/bin:$PATH"
```

**Linux**:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Completions

The module automatically loads all `.sh` files from `modules/shell/completions/`:

**Current completion files:**
- `k8s.sh` - Kubernetes utilities and completions

### Adding New Completions

1. Create a new `.sh` file in `modules/shell/completions/`
2. Add your completion functions and aliases
3. The module will automatically source it on shell startup

**Example completion file:**
```bash
# modules/shell/completions/docker.sh
docker-short-aliases() {
  alias d='docker'
  alias dc='docker-compose'
  alias dps='docker ps'
}

# Auto-initialize aliases
docker-short-aliases
```

## Usage Examples

### Basic usage
```nix
{
  programs.shell.enable = true;
  # Uses defaults: zsh, direnv, auto-completions
}
```

### Custom aliases
```nix
{
  programs.shell = {
    enable = true;
    extraAliases = {
      grep = "rg";
      vim = "nvim";
      k = "kubectl";
    };
  };
}
```

### Bash as default shell
```nix
{
  programs.shell = {
    enable = true;
    defaultShell = "bash";
  };
}
```

### Minimal configuration
```nix
{
  programs.shell = {
    enable = true;
    enableDirenv = false;
    enableCompletions = false;
  };
}
```

### Custom completions only
```nix
{
  programs.shell = {
    enable = true;
    enableCompletions = true;
    extraAliases = {
      # Your custom aliases here
    };
  };
}
```

## Integration with Other Modules

The shell module integrates seamlessly with other modules:

- **kube-ps1**: Adds Kubernetes context to right prompt (zsh) or main prompt (bash)
- **nvim**: Shell aliases (vi/vim → nvim) work with shell configuration
- **gcloud**: gcloud command completions work with shell setup

## Platform Support

- **macOS (Darwin)**: Full support with Homebrew integration
- **Linux**: Full support with system package integration
- **All Nix platforms**: Platform-agnostic shell features

## Shell Features

### Zsh Features
- **Auto-completion**: Enhanced completion system
- **Auto-suggestions**: Command suggestions based on history
- **Syntax highlighting**: Real-time command syntax highlighting
- **Right prompt**: Shows additional info without cluttering main prompt

### Bash Features  
- **Compatibility**: Full bash compatibility for scripts
- **Completions**: Standard bash completion support
- **History**: Enhanced history management

## File Structure

```
modules/shell/
├── default.nix          # Main module configuration
├── README.md            # This documentation
└── completions/         # Auto-loaded completion files
    └── k8s.sh           # Kubernetes completions and utilities
```

## Customization

The module is designed to be highly customizable while providing sensible defaults. You can:

1. **Add completions**: Drop `.sh` files in `completions/`
2. **Override aliases**: Use `extraAliases` option
3. **Disable features**: Turn off starship, direnv, or completions
4. **Switch shells**: Choose zsh or bash as default
5. **Platform-specific**: Different configs per platform