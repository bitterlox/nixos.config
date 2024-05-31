{ pkgs, ... }:
let
  scripts = let
    arr = [
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
      name = script.name;
      runtimeInputs = script.runtimeInputs;
      text = "${pkgs.bash}/bin/bash ${./. + "/${script.name}"}";
    }) arr;
in pkgs.symlinkJoin {
  name = "workspace-scripts";
  paths = scripts;
}
