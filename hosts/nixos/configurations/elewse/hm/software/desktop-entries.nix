{ lib, config, options, pkgs, ... }:
let
  makeApp = { name, ... }@argSet: { type = "Application"; } // argSet;
  scripts = (import ./scripts { inherit pkgs; });
in {
  imports = [ ];
  xdg.desktopEntries = {
    popcorntime = makeApp {
      comment = "An application that streams movies and TV shows from torrents";
      exec =
        "popcorntime --enable-features=UseOzonePlatform --ozone-platform=wayland";
      genericName = "Torrent streaming";
      categories = [ "Video" "AudioVideo" ];
      icon = "popcorntime";
      name = "Popcorn-Time";
    };
    thunar = makeApp {
      comment = "A file manager, included in the xfce desktop environment.";
      exec = "thunar";
      genericName = "File Manager";
      name = "Thunar";
    };
    change-wallpaper = makeApp {
      comment = "Execute a script to change the current wallpaper";
      exec =
        ''${lib.getExe scripts.changeWallpaper} /home/angel/Pictures/wallpapers/'';
      genericName = "File Manager";
      name = "Change Wallpaper";
    };
  };
}
