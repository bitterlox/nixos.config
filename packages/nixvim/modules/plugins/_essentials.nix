# this is a nixvim module
args@{ config, lib, ... }:
{
  imports = [
    # fuzzily navigate code
    ./telescope.nix
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
    # ./nvim-cmp.nix
    ./blink-cmp.nix

    # testing
    ./neotest.nix

    # colorizer
    ./colorizer.nix

    # llm companion
    #./codecompanion-nvim.nix

    # remember keymaps
    ./which-key.nix
  ];
  config =
    # let
    #   grammars = config.plugins.treesitter.package.passthru.builtGrammars;
    # in
    {
      plugins.web-devicons.enable = true;

      # plugins.treesitter.grammarPackages = grammars;
      # plugins.treesitter.grammarPackages = lib.mkForce (
      #   with grammars;
      #   [
      #     bash
      #     toml
      #     css
      #     go
      #     json
      #     lua
      #     markdown
      #     nix
      #     rust
      #     typescript
      #     yaml
      #     zig
      #   ]
      # );
    };
}
