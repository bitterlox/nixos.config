# this is a nixvim module
args@{
  config,
  lib,
  options,
  pkgs,
  specialArgs,
  ...
}:
{
  imports = [
    ./set.nix
    ./remaps.nix
    ./diagnostics.nix
    ./colorschemes
  ];
}
