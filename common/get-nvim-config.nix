{pkgs, nvim-config, ...}: let stdenv = pkgs.stdenv; in
  stdenv.mkDerivation {
    name = "get-nvim-config";
    src =  nvim-config;
    installPhase = ''
    echo $out
    cp -r $src $out
    '';
  }
