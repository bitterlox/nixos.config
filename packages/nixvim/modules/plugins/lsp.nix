# this is a nixvim module
args@{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  plugins.lsp.enable = true;
  plugins.lsp.inlayHints = true;
  plugins.lsp.onAttach = ''
    require('telescope.builtin')
    -- 0 = trace
    -- 1 = debug
    -- vim.lsp.log.set_level(0)
  '';

  # lua code - unused, was using only for keybindings and inlayHints
  # plugins.lsp.onAttach = "";

  # lua code - will use when i setup cmp
  # plugins.lsp.capabilities = "";

  ## keybindings ##

  plugins.lsp.keymaps.diagnostic = {
    "dp" = "goto_prev";
    "dn" = "goto_next";
    "<leader>q" = "setloclist";
  };

  plugins.lsp.keymaps.extra = [
    {
      mode = "n";
      key = "gdc";
      action = lib.nixvim.mkRaw "vim.lsp.buf.declaration";
    }
    {
      mode = "n";
      key = "H";
      action = lib.nixvim.mkRaw "vim.lsp.buf.hover";
    }
    {
      mode = "n";
      key = "<C-s>";
      action = lib.nixvim.mkRaw "vim.lsp.buf.signature_help";
    }
    # todo: look into lsp workspaces
    {
      mode = "n";
      key = "<leader>wa";
      action = lib.nixvim.mkRaw "vim.lsp.buf.add_workspace_folder";
    }
    {
      mode = "n";
      key = "<leader>wr";
      action = lib.nixvim.mkRaw "vim.lsp.buf.remove_workspace_folder";
    }
    {
      mode = "n";
      key = "<leader>wl";
      action = lib.nixvim.mkRaw ''
        function() 
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end
      '';
    }
    {
      mode = "n";
      key = "<leader>rn";
      action = lib.nixvim.mkRaw "vim.lsp.buf.rename";
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = lib.nixvim.mkRaw "vim.lsp.buf.code_action";
    }

    {
      mode = "n";
      key = "<leader>f";
      action = lib.nixvim.mkRaw "vim.lsp.buf.format";
    }

    # supercharging with telescope
    {
      mode = "n";
      key = "<leader>d";
      action = lib.nixvim.mkRaw "require('telescope.builtin').diagnostics";
    }
    {
      mode = "n";
      key = "<leader>rr";
      action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references";
    }
    {
      mode = "n";
      key = "<leader>ic";
      action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_incoming_calls";
    }
    {
      mode = "n";
      key = "<leader>oc";
      action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_outgoing_calls";
    }
    {
      mode = "n";
      key = "gd";
      action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
    }
    {
      mode = "n";
      key = "gtd";
      action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_type_definitions";
    }
    {
      mode = "n";
      key = "gi";
      action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_implementations";
    }
  ];
}
