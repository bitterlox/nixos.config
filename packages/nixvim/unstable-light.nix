# this is a nixvim module
args@{
  config,
  helpers,
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
    ./modules/plugins/lsp.nix
    ./modules/plugins/languages/_common.nix
  ];

}
