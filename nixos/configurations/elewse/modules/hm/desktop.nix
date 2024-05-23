angelBaseModule:
{ lib, config, options, pkgs, ... }: {
  imports = [ angelBaseModule ];
  config = {

    # wayland config

    wayland.windowManager.hyprland = {
      enable = true;
      settings = let
        wl-copy = "wl-copy";
        wl-paste = "wl-paste";
      in {
        "$mod" = "SUPER";
        exec-once = [
          "${wl-paste} --type text --watch cliphist store"
          "${wl-paste} --type image --watch cliphist store"
        ];
        bind = [
          "$mod, F, exec, firefox"
          "$mod, T, exec, kitty"
#          "Control_C, exec, ${wl-copy}"
#          "Control_V, exec, ${wl-paste}"
        ];
      };
    };

    home.packages = with pkgs; [ mako wl-clipboard shotman ];

    services.cliphist.enable = true;

    programs.kitty = {
        enable = true;
        keybindings = {
          };
      };

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.11";
  };
}
