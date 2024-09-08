{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [
    pkgs.vimPlugins.neodev-nvim
    pkgs.vimPlugins.nvim-lspconfig
    pkgs.vimPlugins.lsp-inlayhints-nvim
    pkgs.vimPlugins.yuck-vim
    # pkgs.vimPlugins.vim-parinfer
    # this might make the case for the ability to make an instance
    # of our "data" that can hold both plugins and tools
    pkgs.vimPlugins.customPlugins.efmls-configs
  ];
  config =
    [ ../../../../../lua/config/plugins/plugin-config/lsp-inlayhints-nvim.lua ];
}
