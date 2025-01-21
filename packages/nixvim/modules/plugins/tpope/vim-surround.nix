# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {
  # all about surroundings
  plugins.vim-surround.enable = true;
}
