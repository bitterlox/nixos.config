{ pkgs, ... }:
let
  scripts = let
    arr = [
      {
        name = "battery.sh";
        runtimeInputs = with pkgs; [ coreutils libnotify ];
      }
      {
        name = "calendar.sh";
        runtimeInputs = with pkgs; [ coreutils ];
      }
      {
        name = "popup.sh";
        runtimeInputs = with pkgs; [ coreutils ];
        #runtimeInputs = with pkgs; [ coreutils eww kitty ];
      }
      {
        name = "wifi.sh";
        runtimeInputs = with pkgs; [ coreutils ];
      }
      {
        name = "get-workspaces.sh";
        runtimeInputs = with pkgs; [ jq socat ];
      }
      {
        name = "get-active-workspace.sh";
        runtimeInputs = with pkgs; [ jq socat coreutils gawk ];
      }
      {
        name = "change-active-workspace.sh";
        runtimeInputs = with pkgs; [ python3 ];
      }
      {
        name = "get-window-title.sh";
        runtimeInputs = with pkgs; [ jq socat coreutils ];
      }
    ];
  in builtins.map (script:
    pkgs.writeShellApplication {
      inherit (script) runtimeInputs name;
      text = ''${pkgs.bash}/bin/bash ${./. + "/${script.name}"} "$@"'';
    }) arr;
in pkgs.symlinkJoin {
  name = "bar-scripts";
  paths = scripts;
}
