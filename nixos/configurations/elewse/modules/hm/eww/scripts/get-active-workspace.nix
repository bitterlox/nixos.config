{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "get-active-workspace";
  runtimeInputs = with pkgs; [ jq socat coreutils gawk ];
  text = ''
    hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

    socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - |
      stdbuf -o0 awk -F ">>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}"
  '';
}
