# My Dotfiles

Personal cross-platform dotfiles managed with Nix flakes and Home Manager. Supports macOS (Darwin) ARM64 and Linux (ARM64/x86_64).

This has evolved over the years to a little more than just dotfiles. If you're of the opinion these should be dirt
simple, well...

![](https://cloud.githubusercontent.com/assets/64263/19022286/f792b660-88a2-11e6-8133-c9e11555f05a.jpg)

## Quick Start

### Installation

- Clone this repo in _~/dotfiles_
- Copy the EJSON private key to _~/.config/ejson/6f1d653196b2a9639631ddeb19d80f995873c18a0011666d8ee98e3d21ad1d0c_.

```bash
./apply
```

This will:

1. Install/update Nix with flakes enabled
2. Apply Home Manager configuration for your platform
3. Set up all enabled modules and their configurations

### Testing (Linux ARM64 in Docker)

```bash
task test
```

### Uninstalling

```bash
./scripts/uninstall
```

**⚠️ Warning**: This completely removes Nix, Home Manager, and all managed configurations.

## How It Works

- **Nix Flakes**: Declarative, reproducible configuration management
- **Home Manager**: User-level package and configuration management
- **Modular Design**: Platform-specific module selection
- **Custom Namespace**: All modules use `dotfiles.*` to avoid conflicts

### Platform Detection

The flake automatically detects your platform and applies the appropriate configuration:

- **macOS ARM64**: Full feature set with GUI applications
- **Linux ARM64/x86_64**: Server-focused configuration

## Available Modules

| Module     | Description                                            | Darwin | Linux |
| ---------- | ------------------------------------------------------ | ------ | ----- |
| `shell`    | Zsh/Bash with completions, aliases, and custom scripts | ✅     | ✅    |
| `git`      | Git configuration with delta, aliases, and signing     | ✅     | ✅    |
| `nvim`     | Neovim with LazyVim and LSPs managed via Nix           | ✅     | ✅    |
| `tmux`     | Terminal multiplexer with vim-style bindings           | ✅     | ✅    |
| `ripgrep`  | Fast text search with custom file types                | ✅     | ✅    |
| `gcloud`   | Google Cloud SDK with configurable components          | ✅     | ✅    |
| `kube-ps1` | Kubernetes prompt for shell                            | ✅     | ✅    |
| `dev`      | Development tools (Go, Rust, Node.js, Python)          | ✅     | ✅    |
| `rejson`   | JSON/eJSON manipulation tool                           | ✅     | ✅    |
| `keybase`  | Keybase and GPG with platform-specific pinentry        | ✅     | ✅    |

### Module Configuration

Modules are configured in `systems/darwin.nix` or `systems/linux.nix`:

```nix
# Enable modules for this platform
enabledModules = [
  "shell" "git" "nvim" "tmux" "ripgrep"
  "dev" "gcloud" "kube-ps1" "rejson" "keybase"
];

# Configure individual modules
dotfiles.git = {
  userName = "Your Name";
  userEmail = "you@example.com";
};

dotfiles.nvim.lazyVim = {
  colorscheme = "catppuccin";
};
```

## Development Tasks

Uses [Task](https://taskfile.dev) for development workflow:

```bash
# Format all code
task fmt

# Run all linting checks
task lint

# Auto-fix issues
task fix

# Find dead code
task dead

# Development workflow (format + check)
task dev

# Clean up
task clean
```

## Project Structure

```
.
├── apply                    # Installation script
├── taskfile.yaml          # Development tasks
├── flake.nix              # Main flake configuration
├── modules/               # Custom Home Manager modules
│   ├── shell/            # Shell configuration with custom scripts
│   ├── git/              # Git configuration
│   ├── nvim/             # Neovim with LazyVim
│   ├── tmux/             # Terminal multiplexer
│   ├── ripgrep/          # Text search configuration
│   ├── gcloud/           # Google Cloud SDK
│   ├── kube-ps1/         # Kubernetes shell prompt
│   ├── dev/              # Development tools
│   ├── rejson/           # JSON/eJSON tools
│   └── keybase/          # Keybase and GPG
├── systems/              # Platform-specific configurations
│   ├── darwin.nix        # macOS configuration
│   └── linux.nix         # Linux configuration
└── scripts/              # Utility scripts
    └── uninstall         # Complete removal script
```

## Key Features

### Shell Environment

- Modern shell tools (eza, bat, fzf, fd)
- Custom scripts auto-installed as executables
- Kubernetes completion and prompt
- Directory-based environment with direnv

### Development Setup

- Language servers and formatters managed via Nix
- No global tool installation required
- Consistent environment across platforms
- Pre-configured development tools

### Secret Management

- eJSON integration for encrypted secrets
- Automatic decryption and environment setup
- Keybase integration for key management

### Cross-Platform Support

- Automatic platform detection
- Platform-specific optimizations
- Consistent experience across macOS and Linux

## Customization

Fork this repository and:

1. Update personal information in `systems/` files
2. Modify module configurations as needed
3. Add/remove modules from `enabledModules` lists
4. Customize shell scripts in `modules/shell/scripts/`

The modular design makes it easy to adapt to your specific needs while maintaining the benefits of Nix's reproducible configuration management.
