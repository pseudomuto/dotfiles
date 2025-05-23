{ config, lib, pkgs, ...}:
let
  homeDir = builtins.getEnv "HOME";
in
{
  _module.args.isLinux = false;

  imports = [
    ./common.nix
    ../apps/ejson.nix
    ../apps/git.nix
    ../apps/go.nix
    ../apps/gpg.nix
    ../apps/keybase.nix
    ../apps/nix.nix
    ../apps/python.nix
    ../apps/shell.nix
    ../apps/task.nix
    ../apps/tmux.nix
    ../apps/vim.nix
  ];

  home.enableNixpkgsReleaseCheck = false;

  # Ok, this is where it all gets weird. I understand that using two package
  # managers has some potential downsides. However, when setting up a new OSX
  # machine, I require a bunch of UI apps to be installed, not just nix packages.
  #
  # This fuckery below installs brew and everything in the Brewfile which I've
  # intentionally limited to things like 1password, dropbox, iterm2, etc.

  home.file.".config/brew/Brewfile".source = ../files/Brewfile;
  home.file.".config/rclone/rclone.conf".source = ../files/rclone.conf;

  home.packages = with pkgs; [
    cmake
    nerd-fonts.recursive-mono
    jdk21
    kcat
    luajitPackages.luarocks_bootstrap
    pinentry_mac
    rclone
    rustup
    tmuxp
  ];

  home.activation.installHomebrew = lib.hm.dag.entryAfter["installPackages"] ''
    if ! which brew >/dev/null; then
      $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  home.activation.brewInstall = lib.hm.dag.entryAfter ["installHomebrew"] ''
    brewfile="${homeDir}/.config/brew/Brewfile"
    $DRY_RUN_CMD brew bundle check --file "$brewfile" || brew bundle install --file "$brewfile" --cleanup
  '';
}
