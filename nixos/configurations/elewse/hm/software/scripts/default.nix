
# todo: pass this as specialArgs
{ pkgs, ... }: {
  changeWallpaper = let name = "change-wallpaper.sh";
  in pkgs.writeShellApplication {
    inherit name;
    # idea: turn this script into a systemd user service that symlinks one pic
    # to $HOME/.config/wallpaper, which is then used in other spots to be
    # wallpaper. This would probably allow me to avoid sleeping before setting
    # hyprland wallpaper (since we'd be setting it in config and not
    # imperatively), and would also allo my to easily use that file path
    # in other palaces (like hyprlock)
    #    runtimeInputs = with pkgs; [ findutils coreutils gnugrep];
    text = ''${pkgs.bash}/bin/bash ${./. + "/${name}"} "$@"'';
  };
}
