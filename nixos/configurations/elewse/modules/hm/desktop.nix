angelBaseModule:
{ lib, config, options, pkgs, ... }:
let
  overrides = {
    eww = pkgs.eww.overrideAttrs (oldAttrs: {
      cargoBuildFlags = oldAttrs.cargoBuildFlags ++ [ "--features=wayland" ];
      buildInputs = [ pkgs.gtk-layer-shell ];
    });
  };
in {
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

    home.packages = let
      overriden = [ ];
      vanilla = with pkgs; [ mako wl-clipboard shotman ];
    in overriden ++ vanilla;

    services.cliphist.enable = true;
    programs.eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = pkgs.writeTextDir "config/foo.yuck" "";
    };

    programs.kitty = {
      enable = true;
      keybindings = { };
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
