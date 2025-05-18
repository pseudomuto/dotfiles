{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.file.".config/tmux/appearance.conf".source = ../files/tmux-appearance.conf;
    home.file.".config/tmux/vim.conf".source = ../files/tmux-vim.conf;

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      shortcut = "a";
      terminal = "screen-256color";

      extraConfig = ''
        # Split windows with more logical keys
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # Remap movement keys
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        setw -g pane-base-index 1
        set -g default-command "$SHELL"

        bind V source-file ${homeDir}/.config/tmux/vim.conf
        source-file ${homeDir}/.config/tmux/appearance.conf
      '';
    };
  };
}
