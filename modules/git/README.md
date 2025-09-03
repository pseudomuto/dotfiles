# Git Module

This module provides comprehensive git configuration with sensible defaults and extensive customization options.

## Features

- **Smart defaults**: Pre-configured with best practices for modern git workflows
- **Delta integration**: Beautiful diffs with syntax highlighting
- **Useful aliases**: Common shortcuts and powerful custom commands
- **Global gitignore**: Ignore common files across all repositories
- **Platform-aware**: Automatic configuration for macOS/Linux differences
- **Auto-correction**: Fixes typos in git commands automatically

## Options

### `programs.git.enable`
- **Type**: boolean
- **Default**: Enabled if "git" is in enabledModules
- **Description**: Enable git with custom configuration

### `programs.git.userName`
- **Type**: null or string
- **Default**: `null`
- **Description**: Git user name for commits
- **Example**: `"John Doe"`

### `programs.git.userEmail`
- **Type**: null or string
- **Default**: `null`
- **Description**: Git user email for commits
- **Example**: `"john.doe@example.com"`

### `programs.git.defaultBranch`
- **Type**: string
- **Default**: `"main"`
- **Description**: Default branch name for new repositories

### `programs.git.editor`
- **Type**: string
- **Default**: `"nvim"` if nvim module is enabled, otherwise `"vim"`
- **Description**: Default editor for git operations

### `programs.git.delta.enable`
- **Type**: boolean
- **Default**: `true`
- **Description**: Enable delta for better diffs

### `programs.git.delta.options`
- **Type**: attribute set
- **Default**: See configuration below
- **Description**: Delta configuration options

### `programs.git.aliases`
- **Type**: attribute set of strings
- **Default**: See aliases section below
- **Description**: Git command aliases

### `programs.git.extraConfig`
- **Type**: attribute set
- **Default**: `{}`
- **Description**: Additional git configuration

### `programs.git.ignores`
- **Type**: list of strings
- **Default**: Common OS and editor files
- **Description**: Global gitignore patterns

## Default Configuration

### Core Settings
- **Auto CRLF**: Set to "input" for cross-platform compatibility
- **Default branch**: "main" for new repositories
- **Push**: Automatically sets up remote tracking, pushes to current branch
- **Pull**: Rebases by default, fast-forward only
- **Fetch**: Auto-prunes deleted branches and tags
- **Diff**: Uses histogram algorithm, shows moved lines in different color
- **Merge**: Shows three-way diff in conflicts
- **Rerere**: Remembers resolved conflicts
- **Rebase**: Auto-stashes changes, auto-squashes fixup commits

### Default Aliases

```bash
# Shortcuts
git st          # status
git co          # checkout
git br          # branch
git ci          # commit

# Useful commands
git unstage     # Unstage files
git last        # Show last commit
git lg          # Pretty graph log
git recent      # Show recent branches
git amend       # Amend without editing message
git pushf       # Force push with lease (safer)
```

### Shell Aliases

The module also adds shell aliases:
```bash
gs              # git status
gap             # git add -p (interactive staging)
gcm             # git commit -m
gpr             # git pull --rebase
gds             # git diff --staged
```

### Default Global Ignores

- OS files: `.DS_Store`, `Thumbs.db`, etc.
- Editor files: `*.swp`, `.idea/`, `.vscode/`, etc.
- Language specific: `__pycache__/`, `node_modules/`, `.env`

## Usage Examples

### Basic configuration with user info
```nix
{
  programs.git = {
    enable = true;
    userName = "John Doe";
    userEmail = "john@example.com";
  };
}
```

### Custom aliases
```nix
{
  programs.git = {
    enable = true;
    aliases = {
      # Keep defaults and add custom ones
      undo = "reset HEAD~1 --mixed";
      wip = "!git add -A && git commit -m 'WIP'";
      save = "!git add -A && git commit -m 'SAVEPOINT'";
    };
  };
}
```

### Additional configuration
```nix
{
  programs.git = {
    enable = true;
    extraConfig = {
      merge.tool = "vimdiff";
      commit.gpgsign = true;
      user.signingkey = "YOUR_GPG_KEY";
    };
  };
}
```

### Custom ignore patterns
```nix
{
  programs.git = {
    enable = true;
    ignores = [
      "*.log"
      "*.tmp"
      "build/"
      "dist/"
      ".cache/"
    ];
  };
}
```

### Disable delta
```nix
{
  programs.git = {
    enable = true;
    delta.enable = false;
  };
}
```

### Configure delta options
```nix
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        navigate = true;
        syntax-theme = "Dracula";
      };
    };
  };
}
```

## Platform-Specific Features

### macOS
- Automatically uses macOS keychain for credential storage

### Linux
- Uses system credential helper if available

## Integration with Other Modules

- **nvim**: Automatically sets nvim as the git editor when enabled
- **shell**: Provides git-related shell aliases
- **ripgrep**: Can be used as a fast alternative to git grep

## Tips and Tricks

### Interactive staging
```bash
gap  # or git add -p
# Interactively choose hunks to stage
```

### Better logs
```bash
git lg  # Pretty graph view
git recent  # See recent branch activity
```

### Safer force pushing
```bash
git pushf  # Uses --force-with-lease
# Only force pushes if remote hasn't changed
```

### Fix typos automatically
Git will auto-correct typos after 1 second:
```bash
git statsu  # Automatically runs 'git status'
```

## File Structure

```
modules/git/
├── default.nix    # Module configuration
└── README.md      # This documentation
```