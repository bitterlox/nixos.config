# this is a nixvim module
args@{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  # let
  #   luaconfig = pkgs.writeTextFile {
  #     name = "nvim-cokeline.lua";
  #     text = ''
  #       require("tmux").setup({})
  #     '';
  #   };
  # in {
  #   extraPlugins = [{
  #     plugin = pkgs.vimPlugins.tmux-nvim;
  #     config = "luafile ${luaconfig}";
  #   }];
  plugins.tmux-navigator.enable = true;
}
