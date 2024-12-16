{ lib, config, options, pkgs, ... }: {
  imports = [ ];
  config = {
# todo eww bar:
# - add bluetooh widget
# - add small widgtet to switch power profiles with
#   powerprofilesctl
    programs.eww = {
      enable = true;
      package = pkgs.eww;
      configDir = let
        eww-yuck = pkgs.writeTextDir "eww.yuck" ''
          (include "${(import ./bar { inherit pkgs; })}/bar.yuck")
        '';
        styles-scss = pkgs.writeTextDir "eww.scss" ''
          @import "${./bar/bar.scss}";
        '';
      in pkgs.symlinkJoin {
        name = "eww-config";
        paths = [ eww-yuck styles-scss ];
        #postBuild = "echo links added";
      };
    };

  };
}
