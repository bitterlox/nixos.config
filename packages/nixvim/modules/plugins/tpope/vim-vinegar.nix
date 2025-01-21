# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {
  # improved netrw
  extraPlugins = [ pkgs.vimPlugins.vim-vinegar ];
}
