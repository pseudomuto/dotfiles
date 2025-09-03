# Dockerfile for testing Linux ARM64 installation
FROM ubuntu:22.04

# Install base dependencies
RUN apt-get update && apt-get install -y \
  curl \
  git \
  sudo \
  xz-utils \
  ca-certificates \
  locales \
  systemd \
  && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Create test user with sudo privileges
RUN useradd -m -s /bin/bash nixuser && \
  echo "nixuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy dotfiles directory
COPY . /home/nixuser/dotfiles/
RUN chown -R nixuser:nixuser /home/nixuser/dotfiles

# Switch to test user
USER nixuser
ENV USER=nixuser
WORKDIR /home/nixuser/dotfiles

# Run the apply script to install and configure everything
RUN ./apply

# Set up environment variables for the installed packages
ENV PATH="/home/nixuser/.nix-profile/bin:/nix/var/nix/profiles/default/bin:${PATH}"

# Change the default shell to zsh after Home Manager setup
# Use readlink to get the actual nix store path of zsh
RUN ZSH_PATH=$(readlink -f /home/nixuser/.nix-profile/bin/zsh) && \
  echo "Found zsh at: $ZSH_PATH" && \
  echo "$ZSH_PATH" | sudo tee -a /etc/shells && \
  sudo usermod -s "$ZSH_PATH" nixuser && \
  echo "Shell changed to: $(grep nixuser /etc/passwd | cut -d: -f7)"

# Verify installation by checking some packages are available
RUN which nvim && which bat && which eza && echo "✓ Packages installed successfully"

# Show what's installed in the user profile
RUN nix profile list | head -10

# Default shell - use the user's configured shell
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["exec $(grep nixuser /etc/passwd | cut -d: -f7) -l"]
