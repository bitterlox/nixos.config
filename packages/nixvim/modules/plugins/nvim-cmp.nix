# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {

  plugins.cmp.enable = true;

  # completion sources
  # maybe i should switch to auto enable sources
  # TODO: add
  # - cmp-nvim-lsp-signature-help 
  # - cmp-nvim-lsp-document-symbol
  # - otter.nvim
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-cmdline.enable = true;
  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp_luasnip.enable = true;

  # plugins.cmp.settings.autoEnableSoures = true;

  plugins.luasnip.enable = true;
  plugins.friendly-snippets.enable = true;
  # load snippets - this might be redundant
  plugins.luasnip.fromVscode = [ { } ];

  # integrate with lsp

  # thanks to this commit
  # https://github.com/nix-community/nixvim/pull/1776/commits/3a8d4fee35642ee326f5fea8ddb7aacd1176f23e
  plugins.lsp.capabilities = ''
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )
  '';

  # luasnip

  # this defines how nvim-cmp interacts with the snippet engine
  plugins.cmp.settings.snippet.expand = ''
    function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end
  '';

  plugins.cmp.settings.experimental.ghost_text = true;

  # plugins.cmp.settings.window = {
  #   completion = "require('cmp').config.window.bordered()";
  #   documentation = "require('cmp').config.window.bordered()";
  # };

  plugins.cmp.settings.mapping = {
    # next item
    "<S-Tab>" =
      "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
    # previous item
    "<Tab>" =
      "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
    # scroll back docs
    "<C-b>" = "cmp.mapping.scroll_docs(-4)";
    # scroll forward docs
    "<C-f>" = "cmp.mapping.scroll_docs(4)";
    # start completion
    "<C-Space>" = "cmp.mapping.complete()";
    # stop completion
    "<C-e>" = "cmp.mapping.abort()";
    # accept selected completion suggestion (also enter key works for this)
    # Accept currently selected item. Set `select` to `false` to
    # only confirm explicitly selected items.
    "<CR>" = "cmp.mapping.confirm({ select = true })";
  };

  # more completion sources: 
  # https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
  plugins.cmp.settings.sources = [
    { name = "nvim_lsp"; }
    { name = "luasnip"; }
    { name = "cmp-plugins"; }
    { name = "buffer"; }
  ];

  plugins.cmp.cmdline = {
    "/" = {
      mapping = helpers.mkRaw "cmp.mapping.preset.cmdline()";
      sources = [{ name = "buffer"; }];
    };

    "?" = {
      mapping = helpers.mkRaw "cmp.mapping.preset.cmdline()";
      sources = [{ name = "buffer"; }];
    };

    ":" = {
      mapping = helpers.mkRaw "cmp.mapping.preset.cmdline()";
      sources = [
        {
          name = "path";
          group_index = 1;
        }
        {
          name = "cmdline";
          group_index = 2;
        }
      ];
    };
  };
}
