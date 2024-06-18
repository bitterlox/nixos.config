{ pkgs, ... }: {
  changeWallpaper = let name = "change-wallpaper.sh";
  in pkgs.writeShellApplication {
    inherit name;
    #    runtimeInputs = with pkgs; [ findutils coreutils gnugrep];
    text = ''${pkgs.bash}/bin/bash ${./. + "/${name}"} "$@"'';
  };
}
