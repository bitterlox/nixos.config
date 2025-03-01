{ pkgs, ... }:
let
  scripts = (import ./scripts { inherit pkgs; });

  # TODO:
  # - enable volume widget
  # - add an app launcher
  # - make workspaces thing more useful
  # - battery: change icon when plugged in

  batteryScript = "${scripts}/bin/battery.sh";
  calendarScript = "${scripts}/bin/calendar.sh";
  popupScript = "${scripts}/bin/popup.sh";
  wifiScript = "${scripts}/bin/wifi.sh";
  getWorkspacesScript = "${scripts}/bin/get-workspaces.sh";
  getActiveWorkspaceScript = "${scripts}/bin/get-active-workspace.sh";
  changeActiveWorkspaceScript = "${scripts}/bin/change-active-workspace.sh";
  getWindowTitleScript = "${scripts}/bin/get-window-title.sh";

in pkgs.stdenv.mkDerivation {
  name = "bar";
  bash = "${pkgs.bash}/bin/bash";
  eww = "${pkgs.eww}/bin/eww";
  inherit batteryScript calendarScript popupScript wifiScript
    getWorkspacesScript getActiveWorkspaceScript changeActiveWorkspaceScript
    getWindowTitleScript;
  dontUnpack = true;
  src = ./bar.yuck;
  installPhase = ''
    mkdir $out
    substituteAll $src $out/bar.yuck
  '';
  #  executable = true;
  #  destination = "/bin/my-file";
}
