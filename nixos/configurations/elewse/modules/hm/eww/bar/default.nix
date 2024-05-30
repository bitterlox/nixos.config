{ pkgs, ... }:
let
  get-workspaces = "${
      (import ./scripts/get-workspaces.nix { inherit pkgs; })
    }/bin/get-workspaces";

  get-active-workspace = "${
      (import ./scripts/get-active-workspace.nix { inherit pkgs; })
    }/bin/get-active-workspace";
  change-active-workspace = "${
      (import ./scripts/change-active-workspace.nix { inherit pkgs; })
    }/bin/change-active-workspace";
  get-window-title = "${
      (import ./scripts/get-window-title.nix { inherit pkgs; })
    }/bin/get-window-title";
in pkgs.writeTextFile {
  name = "bar.eww";
  text = ''
  '';
  #  executable = true;
  #  destination = "/bin/my-file";
}
