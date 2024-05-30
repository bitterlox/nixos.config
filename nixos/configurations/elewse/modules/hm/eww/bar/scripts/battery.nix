{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "battery";
  runtimeInputs = with pkgs; [];
  text = ''
  '';
}
