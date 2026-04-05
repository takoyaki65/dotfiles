{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    historyLimit = 10000;
    keyMode = "vi";
    escapeTime = 250;

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",*256col*:RGB"

      # Focus events (for vim autoread)
      set -g focus-events on

      # Renumber windows
      set -g renumber-windows on

      # Pane base index
      setw -g pane-base-index 1

      # Split panes (intuitive keys)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # New window in current path
      bind c new-window -c "#{pane_current_path}"

      # Pane navigation (vim-tmux-navigator integration)
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

      # Pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Quick pane cycling
      bind -n M-o select-pane -t :.+

      # Zoom pane toggle
      bind z resize-pane -Z

      # Kill pane/window without confirmation
      bind x kill-pane
      bind X kill-window

      # Copy mode
      bind v copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Clipboard (OSC52)
      set -g set-clipboard on

      # Status bar
      set -g status-position bottom
      set -g status-style 'bg=colour235 fg=colour250'
      set -g status-left '#[fg=colour232,bg=colour39,bold] #S #[fg=colour39,bg=colour235] #h #[bg=colour235] '
      set -g status-left-length 40
      set -g status-right '#[fg=colour250] #P/#{window_panes} #[fg=colour250]%Y-%m-%d #[fg=colour39]%H:%M '
      setw -g window-status-format ' #I:#W '
      setw -g window-status-current-format '#[fg=colour39,bold] #I:#W '

      # Pane borders
      set -g pane-border-style 'fg=colour238'
      set -g pane-active-border-style 'fg=colour39'

      # Dim unfocused panes
      set -g window-active-style 'bg=terminal'
      set -g window-style 'bg=colour236'

      # Message style
      set -g message-style 'bg=colour39 fg=colour232 bold'
    '';
  };
}
