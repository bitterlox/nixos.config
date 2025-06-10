{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  scripts = (import ./scripts { inherit pkgs; });
in
{
  # force electron apps to use wayland
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # https://nixos.org/manual/nixos/stable/release-notes.html#sec-release-22.05-notable-changes
    # yet another one of these
    NIXOS_OZONE_WL = "1";
  };
  # home.file.".config/electron-flags.conf" = {
  #   enable = true;
  #   text = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  # };
  # wayland config
  wayland.windowManager.hyprland = {
    enable = true;
    package = osConfig.programs.hyprland.package;
    settings = {
      # This is an example Hyprland config file.
      # Refer to the wiki for more information.
      # https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

      # Please note not all available settings / options are set here.
      # For a full list, see the wiki

      # You can split this configuration into multiple files
      # Create your files separately and then link them to this file like this:
      # source = ~/.config/hypr/myColors.conf

      ###################
      ###   BINDINGS  ###
      ###################

      # for keychron k6 in window mode;
      # todo: figure out how to turn this off for laptop keyboard
      "$mod" = "SUPER";

      # See https://wiki.hyprland.org/Configuring/Keywords/
      # Set programs that you use
      "$terminal" = "ghostty";
      "$fileManager" = "thunar";
      "$menu" = "tofi-drun | xargs hyprctl dispatch exec --";
      "$lock" = "hyprlock --immediate";
      "$firefox-browser" = "librewolf";
      "$chrome-browser" = "chromium";
      ###################
      #### AUTOSTART ####
      ###################

      # Autostart necessary processes (like notifications daemons, status bars, etc.)
      # Or execute your favorite apps at launch like this:

      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        #"eww daemon"
        "eww open bar"
        "sleep 3; ${lib.getExe scripts.changeWallpaper} $HOME/Pictures/wallpapers/"
      ];

      # exec-once = $terminal
      # exec-once = nm-applet &
      # exec-once = waybar & hyprpaper & firefox

      ###################
      #### ENV VARS #####
      ###################

      # See https://wiki.hyprland.org/Configuring/Environment-variables/

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
      ];

      ###################
      ## LOOK AND FEEL ##
      ###################

      # Refer to https://wiki.hyprland.org/Configuring/Variables/

      # https://wiki.hyprland.org/Configuring/Variables/#general
      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#decoration
      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#animations
      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master = {
        new_status = "master";
      };

      # https://wiki.hyprland.org/Configuring/Variables/#misc
      misc = {
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };
      #############
      ### INPUT ###
      #############

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "pc104";
        kb_options = "ctrl:nocaps";
        kb_rules = "";

        follow_mouse = 1;

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = 1;
        };
      };

      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      gestures = {
        workspace_swipe = true;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      # device = {
      #     name = epic-mouse-v1
      #     sensitivity = -0.5
      # }

      ###################
      ### KEYBINDINGS ###
      ###################

      # todo: setup print key to open a screenshot program

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      # can use wev program to find key names
      bind = [
        "$mod, T, exec, $terminal"
        "$mod, F, exec, $firefox-browser"
        "$mod, C, exec, $chrome-browser"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, SPACE, exec, $menu"
        "$mod, L, exec, $lock"
        "$mod, P, pseudo," # dwindle
        "$mod, J, togglesplit," # dwindle

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"

        # workspaces
        "$mod, TAB, workspace, e+1"
        "$mod SHIFT, TAB, workspace, e-1"
        "$mod, backspace, workspace, previous"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        # trigger when the switch is toggled
        # should make this conditional on external monitor disconnected
        ", switch:off:Lid Switch, exec, pidof hyprlock || hyprlock"
      ];

      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

      # Example windowrule v1
      #windowrule = "float, ^(kitty)$";
      # Example windowrule v2
      #windowrulev2 = "float,class:^(kitty)$,title:^(kitty)$";

      #windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.

      ## debug##

      debug = {
        disable_logs = false;
      };
    };
  };

  # not suppported yet, added here
  # https://github.com/nix-community/home-manager/commit/445d721ecfbd92d83f857f12f1f99f5c8fa79951
  # home.pointerCursor.hyprcursor.enable = true;
}
