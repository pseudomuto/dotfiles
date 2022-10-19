{ config, lib, pkgs, ...}:
let
  homeDir = builtins.getEnv "HOME";
in
{
  _module.args.isLinux = false;

  imports = [
    ./common.nix
    ../apps/cockroachdb.nix
    ../apps/ejson.nix
    ../apps/git.nix
    ../apps/go.nix
    ../apps/gpg.nix
    ../apps/keybase.nix
    ../apps/nix.nix
    ../apps/nvim.nix
    ../apps/python.nix
    ../apps/shell.nix
    ../apps/tmux.nix
  ];

  # Ok, this is where it all gets weird. I understand that using two package
  # managers has some potential downsides. However, when setting up a new OSX
  # machine, I require a bunch of UI apps to be installed, not just nix packages.
  #
  # This fuckery below installs brew and everything in the Brewfile which I've
  # intentionally limited to things like 1password, dropbox, iterm2, etc.

  home.file.".config/brew/Brewfile".source = ../files/Brewfile;

  home.packages = with pkgs; [
    nodePackages.firebase-tools
    nodePackages.pnpm
  ];

  home.activation.installHomebrew = lib.hm.dag.entryAfter["linkGeneration"] ''
    if ! which brew >/dev/null; then
      $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  home.activation.brewInstall = lib.hm.dag.entryAfter ["installHomebrew"] ''
    brewfile="${homeDir}/.config/brew/Brewfile"
    $DRY_RUN_CMD brew bundle check --file "$brewfile" || brew bundle install --file "$brewfile" --cleanup
  '';
}
