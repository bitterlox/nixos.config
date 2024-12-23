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
    monitor = [
      ",preferred,auto,1"
    ];

    # exec-once = [ "shikane" ];

    # bind = [
    #   "$mod SHIFT, D, exec, shikanectl switch docked"
    #   "$mod SHIFT, U, exec, shikanectl switch undocked"
    # ];

    bindl =
      let
        grabEDP = "hyprctl monitors | grep -Eo 'eDP-.'";
        externalMonitorDesc = "ASUSTek COMPUTER INC PG32UCDM S5LMQS055583";
        laptopMonitorDesc = "BOE 0x0BC9C";
        enableLaptop = "EDP=''$(${grabEDP}) hyprctl keyword monitor $EDP, preferred, auto, auto";
        enableExternal = "hyprctl keyword monitor desc:'${externalMonitorDesc}', preferred, auto, auto";
        disableLaptop = "EDP=''$(${grabEDP}) hyprctl keyword monitor $EDP, disable";
        disableExternal = "hyprctl keyword monitor desc:'${externalMonitorDesc}', disable";
      in
      [
        "$mod SHIFT, D, exec, (${enableExternal}; ${disableLaptop})"
        "$mod SHIFT, U, exec, (${enableLaptop}; ${disableExternal})"
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

  # due to bugginess in automatically switching monitors using manual for now
  # home.packages = [ pkgs.shikane ];

  # xdg.configFile."shikane/config.toml" = {
  #   enable = true;
  #   source = ./shikane.toml;
  # };

}
