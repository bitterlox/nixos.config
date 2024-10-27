# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  # improved netrw
  extraPlugins = [ pkgs.vimPlugins.vim-vinegar ];
}
