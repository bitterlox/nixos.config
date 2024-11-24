# this is a nixvim module
args@{ config, helpers, lib, options, specialArgs }: {
  imports = [
    # fuzzily navigate code
    ./plugins/telescope.nix
    # status line
    ./plugins/nvim-cokeline.nix
    # tmux integration
    ./plugins/tmux-nvim.nix

    # comment stuff
    ./plugins/tpope/vim-commentary.nix
    # git client
    ./plugins/tpope/vim-fugitive.nix
    # repeat commands
    ./plugins/tpope/vim-repeat.nix
    # surround text
    ./plugins/tpope/vim-surround.nix
    # improved netrw
    ./plugins/tpope/vim-vinegar.nix

    # tree sitter
    ./plugins/tree-sitter.nix
    # tree of past changes to go back to
    ./plugins/undo-tree.nix

    # completion
    ./plugins/nvim-cmp.nix

    # lsps #

    # common language plugins + lsp config
    ./plugins/languages/common.nix
    # golang lsp
    ./plugins/languages/go.nix
    ./plugins/languages/tsserver.nix
  ];
  config = { plugins.web-devicons.enable = true; };
}
