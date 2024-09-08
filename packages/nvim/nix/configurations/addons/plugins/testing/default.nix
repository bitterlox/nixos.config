{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [
    pkgs.vimPlugins.neotest
    pkgs.vimPlugins.neotest-go
    pkgs.vimPlugins.neotest-jest
  ];
  config = [
    ../../../../../lua/config/plugins/plugin-config/neotest.lua
    ../../../../../lua/config/plugins/plugin-keybindings/neotest.lua
  ];
}

