# SDKMAN Module

This module installs and configures [SDKMAN!](https://sdkman.io/), the Software Development Kit Manager for managing multiple versions of SDKs on Unix-based systems.

## Features

- Automatically downloads and installs SDKMAN during Home Manager activation
- Configures shell initialization for Bash, Zsh, and Fish
- Provides configurable SDKMAN directory location
- Supports automatic installation of SDK candidates
- Manages SDKMAN configuration file settings
- Includes required dependencies (curl, zip, unzip)

## Configuration

### Basic Configuration

```nix
dotfiles.sdkman = {
  enable = true;                    # Default: true (when module is enabled)
  installOnActivation = true;       # Default: true
  sdkmanDir = "$HOME/.sdkman";      # Default: "$HOME/.sdkman"
};
```

### With Default Candidates

```nix
dotfiles.sdkman = {
  enable = true;
  candidates = [
    { name = "java"; version = "21.0.5-amzn"; default = true; }
    { name = "java"; version = "17.0.9-amzn"; }
    { name = "gradle"; version = "8.5"; default = true; }
    { name = "maven"; version = "3.9.6"; default = true; }
    { name = "kotlin"; version = "1.9.22"; }
  ];
};
```

The `candidates` option allows you to specify SDKs to install automatically. Each candidate has:
- `name`: The SDK candidate name (e.g., java, gradle, maven)
- `version`: The specific version to install
- `default`: Whether to set this version as the default (optional, defaults to false)

### With Configuration File Settings

```nix
dotfiles.sdkman = {
  enable = true;
  config = {
    sdkman_auto_answer = "false";
    sdkman_selfupdate_feature = "true";
    sdkman_auto_env = "true";
    sdkman_colour_enable = "true";
    sdkman_auto_complete = "true";
    sdkman_curl_connect_timeout = "7";
    sdkman_debug_mode = "false";
  };
  candidates = [
    { name = "java"; version = "21.0.5-amzn"; default = true; }
  ];
};
```

Available configuration options:
- `sdkman_auto_answer`: Make SDKMAN non-interactive (true/false)
- `sdkman_selfupdate_feature`: Check for newer versions and prompt for updates
- `sdkman_auto_env`: Enable automatic environment switching based on .sdkmanrc
- `sdkman_colour_enable`: Enable colored output
- `sdkman_auto_complete`: Enable shell auto-completions
- `sdkman_curl_connect_timeout`: Configure curl connection timeout
- `sdkman_debug_mode`: Enable verbose debugging
- `sdkman_insecure_ssl`: Disable SSL certificate verification (use with caution)

## Usage

After installation, you can use SDKMAN commands like:

```bash
sdk version                    # Check SDKMAN version
sdk list java                 # List available Java versions
sdk install java 11.0.2-open  # Install specific Java version
sdk use java 11.0.2-open      # Use specific Java version for current shell
sdk default java 11.0.2-open  # Set default Java version
```

## Requirements

- Unix-based system (macOS, Linux)
- Bash, Zsh, or Fish shell
- Internet connection for initial download

The module automatically installs the required dependencies (curl, zip, unzip) via Nix.