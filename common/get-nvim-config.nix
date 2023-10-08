{pkgs, nvim-config, ...}: let stdenv = pkgs.stdenv; in
  stdenv.mkDerivation {
    name = "get-nvim-config";
    args = [ ./builder.sh ];
    nvimConfig =  nvim-config;
  }
