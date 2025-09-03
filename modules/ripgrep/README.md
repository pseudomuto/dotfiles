# Ripgrep Module

This module provides ripgrep (rg) with custom configuration for improved searching experience.

## Features

- **Smart defaults**: Pre-configured to ignore common directories (.git, node_modules, vendor)
- **Hidden files**: Searches hidden files by default
- **Column limits**: Sets max columns for better readability
- **Smart case**: Case-insensitive search unless pattern contains uppercase
- **Custom types**: Adds `config` type for YAML and TOML files
- **Extensible**: Easy to add custom patterns and configurations

## Options

### `programs.ripgrep.enable`
- **Type**: boolean
- **Default**: Enabled if "ripgrep" is in enabledModules
- **Description**: Enable ripgrep with custom configuration

### `programs.ripgrep.package`
- **Type**: package
- **Default**: `pkgs.ripgrep`
- **Description**: The ripgrep package to use

### `programs.ripgrep.configFile`
- **Type**: lines
- **Default**: See default configuration below
- **Description**: Contents of the ripgrep configuration file

### `programs.ripgrep.extraConfig`
- **Type**: lines
- **Default**: `""`
- **Description**: Additional configuration to append to the ripgrep config file

## Default Configuration

The module provides these default settings in `~/.config/ripgrep/config`:

```
--glob=!.git/*
--glob=!node_modules/*
--glob=!vendor/*
--hidden
--max-columns=200
--max-columns-preview
--smart-case

--type-add
config:*.{yml,yaml,toml}
```

### Configuration Explained

- `--glob=!.git/*`: Ignore .git directories
- `--glob=!node_modules/*`: Ignore node_modules directories
- `--glob=!vendor/*`: Ignore vendor directories
- `--hidden`: Search hidden files and directories
- `--max-columns=200`: Limit line length in output
- `--max-columns-preview`: Show preview of long lines
- `--smart-case`: Case-insensitive unless pattern has uppercase
- `--type-add config:...`: Define custom type for config files

## Usage Examples

### Basic usage
```nix
{
  programs.ripgrep.enable = true;
  # Uses all defaults
}
```

### Add extra ignore patterns
```nix
{
  programs.ripgrep = {
    enable = true;
    extraConfig = ''
      --glob=!*.min.js
      --glob=!dist/*
      --glob=!build/*
    '';
  };
}
```

### Override default configuration
```nix
{
  programs.ripgrep = {
    enable = true;
    configFile = ''
      --hidden
      --smart-case
      --glob=!.git/*
      # Your custom config
    '';
  };
}
```

### Custom file types
```nix
{
  programs.ripgrep = {
    enable = true;
    extraConfig = ''
      --type-add
      web:*.{html,css,js,jsx,ts,tsx}
      
      --type-add
      docs:*.{md,rst,txt}
    '';
  };
}
```

## Command Line Usage

Once configured, ripgrep will automatically use the config file:

```bash
# Search for "TODO" in all files (respects config)
rg TODO

# Search only in config files (using custom type)
rg --type config "database"

# Temporarily override config
rg --no-ignore TODO  # Search everything including ignored paths
rg -i pattern        # Force case-insensitive
rg -s pattern        # Force case-sensitive
```

## Integration with Other Tools

Ripgrep is commonly used with:
- **fzf**: For fuzzy finding with preview
- **vim/neovim**: As the grep program for searching
- **git**: As a replacement for git grep

Example fzf integration:
```bash
# Add to your shell config
export FZF_DEFAULT_COMMAND='rg --files'
```

## File Structure

```
modules/ripgrep/
├── default.nix    # Module configuration
└── README.md      # This documentation
```