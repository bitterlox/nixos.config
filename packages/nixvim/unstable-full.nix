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
    ./options.nix
    ./modules/editor-config
    ./modules/plugins/_essentials.nix
    ./modules/plugins/_extras.nix
    ./modules/plugins/lsp.nix
    ./modules/plugins/languages/_all.nix
  ];
}
