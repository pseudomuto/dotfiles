{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.tmux;
  isEnabled = elem "tmux" enabledModules;
in
{
  options.dotfiles.tmux = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable tmux terminal multiplexer";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tmux;
      description = "The tmux package to use";
    };

    prefix = mkOption {
      type = types.str;
      default = "C-a";
      description = "Tmux prefix key";
    };

    escapeTime = mkOption {
      type = types.int;
      default = 0;
      description = "Escape time in milliseconds";
    };

    historyLimit = mkOption {
      type = types.int;
      default = 50000;
      description = "History limit for tmux buffers";
    };

    mouse = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mouse support";
    };

    vi = mkOption {
      type = types.bool;
      default = true;
      description = "Enable vi-style key bindings";
    };

    renumberWindows = mkOption {
      type = types.bool;
      default = true;
      description = "Renumber windows when one is closed";
    };

    baseIndex = mkOption {
      type = types.int;
      default = 1;
      description = "Base index for windows and panes";
    };

    terminal = mkOption {
      type = types.str;
      default = "screen-256color";
      description = "Default terminal type";
    };

    statusPosition = mkOption {
      type = types.enum [
        "top"
        "bottom"
      ];
      default = "bottom";
      description = "Position of the status bar";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional tmux configuration";
      example = ''
        bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      pkgs.tmuxinator
    ];

    home.file.".config/tmux/tmux.conf".text = ''
      # Set prefix key
      set-option -g prefix ${cfg.prefix}
      unbind-key C-b
      bind-key ${cfg.prefix} send-prefix

      # Basic settings
      set -g default-command "$SHELL"
      set-option -g focus-events on
      set-option -g escape-time ${toString cfg.escapeTime}
      set-option -g history-limit ${toString cfg.historyLimit}
      set-option -g default-terminal "${cfg.terminal}"
      set-option -g status-position ${cfg.statusPosition}

      # Window and pane indexing
      set-option -g base-index ${toString cfg.baseIndex}
      set-option -g pane-base-index ${toString cfg.baseIndex}
      ${optionalString cfg.renumberWindows "set-option -g renumber-windows on"}

      # Mouse support
      ${optionalString cfg.mouse "set-option -g mouse on"}

      # Vi mode
      ${optionalString cfg.vi ''
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
        bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
      ''}

      # Better pane splitting
      bind-key | split-window -h -c "#{pane_current_path}"
      bind-key - split-window -v -c "#{pane_current_path}"
      unbind-key '"'
      unbind-key %

      # Pane navigation
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Pane resizing
      bind-key -r H resize-pane -L 5
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r L resize-pane -R 5

      # Window navigation
      bind-key -r C-h previous-window
      bind-key -r C-l next-window

      # Reload config
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # status line
      set -g status-justify left
      set -g status-bg default
      set -g status-fg colour12
      set -g status-interval 1
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour137
      set -g status-left ""
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20

      setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

      # window status
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
      set -g status-left ""

      set-option -sg escape-time 250

      # be quiet!
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-window-option -g monitor-activity off
      set-option -g bell-action none

      # True color support
      set-option -ga terminal-overrides ",*256col*:Tc"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      setw -g clock-mode-colour colour135

      # Open vim with C-a V in a new window
      bind V new-window -a -t :1 nvim

      # Additional configuration
      ${cfg.extraConfig}
    '';

    # Tmuxinator configuration
    home.file.".config/tmuxinator/dev.yml".text = ''
      name: dev
      root: <%= Dir.pwd %>

      windows:
        - shell:
            layout: main-horizontal
        - vim:
            layout: main-horizontal
            panes:
              - vim .
    '';
  };
}
