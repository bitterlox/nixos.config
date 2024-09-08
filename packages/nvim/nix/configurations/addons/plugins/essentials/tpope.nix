{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [
    # git client
    pkgs.vimPlugins.vim-fugitive
    # all about { name = "surroundings"; pkgs.vimPlugins.surroundings}
    pkgs.vimPlugins.vim-surround
    # repeat commands
    pkgs.vimPlugins.vim-repeat
    # improved netrw
    pkgs.vimPlugins.vim-vinegar
    # comment stuff
    pkgs.vimPlugins.vim-commentary
  ];
  config = [ ../../../../../lua/config/plugins/plugin-keybindings/vim-fugitive.lua ];
}
