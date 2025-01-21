# this is a nixvim module
args@{
  config,
  helpers,
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
      action = helpers.mkRaw "vim.lsp.buf.declaration";
    }
    {
      mode = "n";
      key = "H";
      action = helpers.mkRaw "vim.lsp.buf.hover";
    }
    {
      mode = "n";
      key = "<C-s>";
      action = helpers.mkRaw "vim.lsp.buf.signature_help";
    }
    # todo: look into lsp workspaces
    {
      mode = "n";
      key = "<leader>wa";
      action = helpers.mkRaw "vim.lsp.buf.add_workspace_folder";
    }
    {
      mode = "n";
      key = "<leader>wr";
      action = helpers.mkRaw "vim.lsp.buf.remove_workspace_folder";
    }
    {
      mode = "n";
      key = "<leader>wl";
      action = helpers.mkRaw ''
        function() 
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end
      '';
    }
    {
      mode = "n";
      key = "<leader>rn";
      action = helpers.mkRaw "vim.lsp.buf.rename";
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = helpers.mkRaw "vim.lsp.buf.code_action";
    }

    {
      mode = "n";
      key = "<leader>f";
      action = helpers.mkRaw "vim.lsp.buf.format";
    }

    # supercharging with telescope
    {
      mode = "n";
      key = "<leader>d";
      action = helpers.mkRaw "require('telescope.builtin').diagnostics";
    }
    {
      mode = "n";
      key = "<leader>rr";
      action = helpers.mkRaw "require('telescope.builtin').lsp_references";
    }
    {
      mode = "n";
      key = "<leader>ic";
      action = helpers.mkRaw "require('telescope.builtin').lsp_incoming_calls";
    }
    {
      mode = "n";
      key = "<leader>oc";
      action = helpers.mkRaw "require('telescope.builtin').lsp_outgoing_calls";
    }
    {
      mode = "n";
      key = "gd";
      action = helpers.mkRaw "require('telescope.builtin').lsp_definitions";
    }
    {
      mode = "n";
      key = "gtd";
      action = helpers.mkRaw "require('telescope.builtin').lsp_type_definitions";
    }
    {
      mode = "n";
      key = "gi";
      action = helpers.mkRaw "require('telescope.builtin').lsp_implementations";
    }
  ];
}
