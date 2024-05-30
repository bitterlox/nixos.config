{ pkgs, ... }:
let
  eww-yuck = pkgs.writeTextDir "eww.yuck" ''
    (include "${(import ./workspaces { inherit pkgs; })}")
  '';
in pkgs.symlinkJoin {
  name = "eww-config";
  paths = [ eww-yuck ];
  postBuild = "echo links added";
}
