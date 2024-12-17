{
  lib,
  config,
  options,
  pkgs,
  ...
}:
{
  programs.tmux.enable = true;
  programs.tmux.extraConfig = ''
    set -g default-shell $SHELL

    set -g mouse on
    set -g default-terminal "xterm"
    set-window-option -g mode-keys vi

    # set prefix
    unbind C-b
    set -g prefix C-a
    bind-key -r C-a send-prefix

    bind-key -T copy-mode-vi 'v' send -X begin-selection
    bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

    set-option -g renumber-windows on

    # add more sensible split window behavior
    bind-key '"' split-window -v -c '#{pane_current_path}'
    bind-key '%' split-window -h -c '#{pane_current_path}'
    bind-key '-' split-window -v -c '#{pane_current_path}'
    # bind-key ' ' split-window -h -c '#{pane_current_path}'

    # smart pane switching with awareness of vim splits
    bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
    bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
    bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
    bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"
    #bind -n C-\ run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys 'C-\') || tmux select-pane -l"

    # change tab order
    bind-key -n C-S-Left "swap-window -t -1; select-window -t -1"
    bind-key -n C-S-Right "swap-window -t +1; select-window -t +1"
  '';
}
