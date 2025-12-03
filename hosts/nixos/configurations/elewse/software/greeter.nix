{ config, pkgs, lib, ... }:
let
  tuigreetTheme =
    "border=lightmagenta;text=lightblue;prompt=lightblue;time=lightmagenta;action=yellow;button=orange;container=lightblue;input=orange";
  hypr-run = pkgs.writeShellScriptBin "hypr-run" ''
    export XDG_SESSION_TYPE="wayland"
    export XDG_SESSION_DESKTOP="Hyprland"
    export XDG_CURRENT_DESKTOP="Hyprland"

    systemd-run --user --scope --collect --quiet --unit="hyprland" \
        systemd-cat --identifier="hyprland" ${pkgs.hyprland}/bin/Hyprland $@

    ${pkgs.hyprland}/bin/hyperctl dispatch exit
  '';
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd ${lib.getExe hypr-run}'';
      # theme support added in 0.9.0
      # --theme ${tuigreetTheme} \
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    Hyprland
  '';
}
