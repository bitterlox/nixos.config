{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [ pkgs.vimPlugins.nvim-cokeline pkgs.vimPlugins.nvim-web-devicons ];
  config = [
    ../../../../../lua/config/plugins/plugin-config/nvim-cokeline.lua
    ../../../../../lua/config/plugins/plugin-keybindings/nvim-cokeline.lua
  ];
}
