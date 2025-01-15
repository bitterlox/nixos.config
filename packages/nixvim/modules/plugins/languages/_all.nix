# this is a nixvim module
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  specialArgs,
}:
{

  plugins.otter.enable = true;

  imports = [
    # common languages
    ./_common.nix

    # golang support
    ./go.nix

    # typescript support
    ./typescript.nix

    # css support
    ./css.nix

    # bash support
    ./bash.nix

    # lua support
    ./lua.nix

    # nix support
    ./rust.nix

    # nix support
    ./nix.nix
  ];
}
