{ osConfig, ... }:
{
  imports = [
    # window compositor
    ./hyprland.nix

    # status bar / desktop widgets
    ./widgets

    # screen locking
    ./hyprlock.nix

    # idle daemon
    ./hyprlock.nix

    # wallpaper manager
    ./hyprpaper.nix

    # app launcher
    ./tofi.nix

    # browsers
    ./browsers

    # manual .desktop entries so that app launcher finds apps to launch
    ./desktop-entries.nix

    # shell configuration
    ./shells.nix
  ];
}
