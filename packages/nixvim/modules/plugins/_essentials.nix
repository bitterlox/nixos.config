# this is a nixvim module
args@{ config, helpers, lib, options, specialArgs }: {
  imports = [
    # fuzzily navigate code
    ./telescope.nix
    # status line
    ./nvim-cokeline.nix
    # tmux integration
    ./tmux-nvim.nix

    # comment stuff
    ./tpope/vim-commentary.nix
    # git client
    ./tpope/vim-fugitive.nix
    # repeat commands
    ./tpope/vim-repeat.nix
    # surround text
    ./tpope/vim-surround.nix
    # improved netrw
    ./tpope/vim-vinegar.nix

    # tree sitter
    ./tree-sitter.nix
    # tree of past changes to go back to
    ./undo-tree.nix

    # completion
    ./nvim-cmp.nix

    # testing
    ./neotest.nix

    # colorizer
    ./colorizer.nix
  ];
  config = { plugins.web-devicons.enable = true; };
}
