{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [ pkgs.vimPlugins.telescope-nvim ];
  config = [
    ../../../../../lua/config/plugins/plugin-config/telescope-nvim.lua
    ../../../../../lua/config/plugins/plugin-keybindings/telescope-nvim.lua
  ];
}
