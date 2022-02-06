{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  files = {
    ".config/tmux/appearance.conf" = { source = ../files/tmux-appearance.conf; };
    ".config/tmux/vim.conf" = { source = ../files/tmux-vim.conf; };
  };

  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      shortcut = "a";
      terminal = "screen-256color";

      extraConfig = ''
        bind V source-file ${homeDir}/.config/tmux/vim.conf
        source-file ${homeDir}/.config/tmux/appearance.conf
      '';
    };
  };
}
