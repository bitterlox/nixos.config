# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  # all about surroundings
  plugins.vim-surround.enable = true;
}
