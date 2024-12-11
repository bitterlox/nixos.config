# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }:
let
  luaconfig = pkgs.writeTextFile {
    name = "nvim-cokeline.lua";
    text = ''
      require("tmux").setup({})
    '';
  };
in {
  extraPlugins = [{
    plugin = pkgs.vimPlugins.tmux-nvim;
    config = "luafile ${luaconfig}";
  }];
}
