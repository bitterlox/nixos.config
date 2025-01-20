# this is a nixvim module
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  specialArgs,
}:
{
  plugins.blink-cmp.enable = true;
  plugins.blink-cmp.settings = {
    signature.enabled = true;
    completion = {
      documentation = {
        auto_show = true;
        auto_show_delay_ms = 500;
      };
      ghost_text.enabled = false;
      menu.auto_show = false;
    };
    keymap = {
      "<Down>" = [
        "select_next"
        "fallback"
      ];
      "<Up>" = [
        "select_prev"
        "fallback"
      ];
      "<Tab>" = [
        "snippet_forward"
        "fallback"
      ];
      "<S-Tab>" = [
        "snippet_backward"
        "fallback"
      ];
      "<C-p>" = [
        "select_prev"
        "fallback"
      ];
      "<C-n>" = [
        "select_next"
        "fallback"
      ];
      "<C-f>" = [
        "scroll_documentation_down"
        "fallback"
      ];
      "<C-b>" = [
        "scroll_documentation_up"
        "fallback"
      ];
      "<C-space>" = [
        "show"
        "show_documentation"
        "hide_documentation"
      ];
      "<C-e>" = [
        "hide"
      ];
      # "<C-y>" = [
      #   "select_and_accept"
      # ];
    };
  };

  # snippets support
  plugins.luasnip.enable = true;
  plugins.friendly-snippets.enable = true;
  # load snippets - this might be redundant
  plugins.luasnip.fromVscode = [ { } ];

  # thanks to this commit
  # https://github.com/nix-community/nixvim/pull/1776/commits/3a8d4fee35642ee326f5fea8ddb7aacd1176f23e
  plugins.lsp.capabilities = # lua
    ''
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require('blink-cmp').get_lsp_capabilities()
      )
    '';

  # compatibility with nvim-cmp plugin
  plugins.blink-compat.enable = true;
}
