# configure monitors stuff:
# - automatically switch over to external monitor when connected

# added manual bindings because apparently hyprland is a bit buggy in this respect
# see: https://github.com/hyprwm/Hyprland/issues/1274
{
  config,
  lib,
  pkgs,
  ...
}:
{

  wayland.windowManager.hyprland.settings = {
    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = "eDP-1,preferred,auto,auto";

    exec-once = [ "shikane" ];

    bind = [
      "$mod SHIFT, D, exec, shikanectl switch docked"
      "$mod SHIFT, U, exec, shikanectl switch undocked"
    ];

    # this was nifty but was making it crash and i don't want to figure this out
    # in the end i'm happy with just automatically switching from / to docked
    # the l flag makes it work even with modifiers active like lockscreen
    # bindl = [
    #   ", switch:on:Lid Switch, exec, hyprctl keyword monitor eDP-1, disable"
    #   # should switch DP-2 with script that finds monitor name automatically
    #   ", switch:off:Lid Switch, exec, hyprctl keyword monitor eDP-1, preferred, auto, auto, mirror, DP-2"
    # ];
  };

  home.packages = [ pkgs.shikane ];

  xdg.configFile."shikane/config.toml" = {
    enable = true;
    source = ./shikane.toml;
  };

  # to config this see nix shell nixpkgs#sway
  # man 5 sway-output

  # services.kanshi = {
  #   enable = true;
  #   systemdTarget = "hyprland-session.target";

  #   # kanshi.profiles is deprecated, use settings

  #   settings = [
  #     {
  #       profile.name = "undocked";
  #       profile.outputs = [{
  #         criteria = "BOE 0x0BC9 "; # laptop display
  #         status = "enable";
  #       }];
  #     }
  #     {
  #       profile.name = "docked-asus-monitor";
  #       profile.outputs = [
  #         {
  #           criteria = "ASUSTek COMPUTER INC PG32UCDM S5LMQS055583";
  #           status = "enable";
  #         }
  #         {
  #           criteria = "BOE 0x0BC9 "; # laptop display
  #           status = "disable";
  #         }
  #       ];
  #     }
  #   ];
  # };
}
