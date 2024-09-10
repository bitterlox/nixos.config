{ pkgs, addon }:
addon.makePluginAddon {
  pkg = [
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.vimdoc
      p.vim
      p.nix
      p.hoon
      p.go
      p.c
      p.lua
      p.rust
      p.typescript
      p.javascript
      p.bash
      p.html
      p.css
      p.bash
      p.scheme
      p.yuck
    ]))
    pkgs.vimPlugins.undotree
  ];
  config = [
    ../../../../../lua/config/plugins/plugin-config/nvim-treesitter.lua
    ../../../../../lua/config/plugins/plugin-keybindings/undotree.lua
  ];
}
