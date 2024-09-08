{ pkgs, addon }:
let
  lsp-essentials = import ./lsp.nix { inherit pkgs addon; };
  status-line = import ./status-line.nix { inherit pkgs addon; };
  telescope = import ./telescope.nix { inherit pkgs addon; };
  tmux = import ./tmux.nix { inherit pkgs addon; };
  tpope = import ./tpope.nix { inherit pkgs addon; };
  tree-sitter = import ./tree-sitter.nix { inherit pkgs addon; };
  themes = import ./themes.nix { inherit pkgs addon; };
  visual-start-search =
    addon.makePluginAddon { pkg = pkgs.vimPlugins.vim-visual-star-search; };
  plenary = addon.makePluginAddon { pkg = pkgs.vimPlugins.plenary-nvim; };
in addon.mergeAddons themes (addon.mergeAddons visual-start-search
  (addon.mergeAddons tree-sitter (addon.mergeAddons tpope
    (addon.mergeAddons tmux (addon.mergeAddons telescope
      (addon.mergeAddons status-line
        (addon.mergeAddons lsp-essentials plenary)))))))
# ^ can replace this with a list of addons and a call to lib.trivial.rfold (or lfold idk)

