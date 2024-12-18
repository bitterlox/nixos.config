##############################################################
#                    TMUX DEFAULTS                           #
#                                                            #
# sessions have windows                                      #
# windows have panes                                         #
#                                                            #
# - prefix+c                 - create window                 #
# - prefix+[n]               - go to window n                #
# - prefix+n                 - go to next                    #
# - prefix+p                 - go to previous                #
#                                                            #
# :swap-windows to swap windows                              #
# to close windows either kill all the panes or prefix+&     #
# to close panes either exit the shell running or prefix+x   #
#                                                            #
# - prefix+%                 - horizontal split              #
# - prefix+"                 - split vertically              #
# - prefix+[arrow-key]       - navigate panes                #
# - prefix+[ { or } ]        - move panes                    #
# - prefix+q                 - toggle pane numbers + select  #
# - prefix+z                 - toggle pane zoom              #
# - prefix+!                 - turn pane into window         #
#                                                            #
# to create new session either                               #
# - call `tmux` when not attached to any other session       #
# - call `tmux new -s <session-name>`                        #
# - whilist in tmux :new command                             #
#                                                            #
# list sessions:                                             #
# - `tmux ls`                                                #
# - prefix-s                                                 #
#                                                            #
# prefix-w to preview windows in sessions                    #
#                                                            #
# `tmux attach` to attach to most recent session or -t arg   #
#  to attach to specific session                             #
#                                                            #
# enter copy mode prefix+[                                   #
# while in copy mode, enter select mode C+v Space            #
#                                                            #
#                                                            #
##############################################################
{
  lib,
  config,
  options,
  pkgs,
  ...
}:
{

  programs.tmux.enable = true;
  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    sensible
    catppuccin
    yank
  ];
  programs.tmux.extraConfig = ''
    set -g default-shell $SHELL

    set -g mouse on
    set -g default-terminal "xterm"
    set-window-option -g mode-keys vi

    set -g @catppuccin_flavor 'mocha' # latte, frappe, macchiato or mocha

    # start numbering stuff from 1
    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    # set prefix
    unbind C-b
    set -g prefix C-a
    bind-key -r C-a send-prefix

    # remap copy mode: selection and yanking to be more vim-like
    # line selection
    bind-key -T copy-mode-vi 'v' send -X begin-selection 
    # rectangle selection
    bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
    bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

    set-option -g renumber-windows on

    # rebind splitting on same keys but make the new pane's
    # cwd be the same one as the pane it split from
    bind-key '"' split-window -v -c '#{pane_current_path}'
    bind-key '%' split-window -h -c '#{pane_current_path}'
    bind-key '-' split-window -v -c '#{pane_current_path}'
    # bind-key ' ' split-window -h -c '#{pane_current_path}'

    # smart pane switching with awareness of vim splits
    # https://github.com/christoomey/vim-tmux-navigator/issues/317#issuecomment-2483129754
    bind-key -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
    bind-key -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
    bind-key -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
    bind-key -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"
    bind-key -n C-\\ run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys 'C-\\') || tmux select-pane -l"

    bind-key -n M-h previous-window
    bind-key -n M-l next-window

    # change tab order
    bind-key -n C-S-Left "swap-window -t -1; select-window -t -1"
    bind-key -n C-S-Right "swap-window -t +1; select-window -t +1"
  '';
}
