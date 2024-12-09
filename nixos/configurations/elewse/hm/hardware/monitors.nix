# configure monitors stuff:
# - automatically switch over to external monitor when connected
{ config, lib, ... }: {

  wayland.windowManager.hyprland.settings = {
    ################
    ### MONITORS ###
    ################

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = "eDP-1,preferred,auto,auto";

    # this was nifty but was making it crash and i don't want to figure this out
    # in the end i'm happy with just automatically switching from / to docked
    # the l flag makes it work even with modifiers active like lockscreen
    # bindl = [
    #   ", switch:on:Lid Switch, exec, hyprctl keyword monitor eDP-1, disable"
    #   # should switch DP-2 with script that finds monitor name automatically
    #   ", switch:off:Lid Switch, exec, hyprctl keyword monitor eDP-1, preferred, auto, auto, mirror, DP-2"
    # ];
  };

  # to config this see nix shell nixpkgs#sway
  # man 5 sway-output

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    # kanshi.profiles is deprecated, use settings

    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [{
          criteria = "eDP-1";
          status = "enable";
        }];
      }
      {
        profile.name = "docked-asus-monitor";
        profile.outputs = [
          {
            criteria = "ASUSTek COMPUTER INC PG32UCDM S5LMQS055583";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
    ];
  };
}
