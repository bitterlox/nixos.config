{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [
    pkgs.vimPlugins.cmp-buffer
    pkgs.vimPlugins.cmp-path
    pkgs.vimPlugins.cmp-cmdline
    # completion sources
    pkgs.vimPlugins.cmp-nvim-lsp
    #cmp-nvim-lu
    pkgs.vimPlugins.cmp_luasnip
    pkgs.vimPlugins.nvim-cmp
    # snippets
    pkgs.vimPlugins.luasnip
    pkgs.vimPlugins.friendly-snippets
  ];
  config = [ ../../../../../lua/config/plugins/extra-config/autocompletion.lua ];
}

