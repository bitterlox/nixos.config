# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  # yuck
  # https://github.com/elkowar/yuck.vim

  # lisps
  #   either https://github.com/bhurlow/vim-parinfer?tab=readme-ov-file
  #   or https://github.com/gpanders/nvim-parinfer

  ## lsp config ##

  # efm - this covers a lot of tools but i don't think i can call 
  # lspconfig.efm.setup multiple times so if i split these up i can never
  # merge the modules or it will break
  # https://github.com/creativenull/efmls-configs-nvim
  # update: i might be able to use an lsp setup hook (see :help lpsconfig) to
  # override (extend) efm settings on a per-lang basis

  # update update: efm is included in nixvim so i guess i'll configure it
  # through it;
  plugins.lsp.enable = true;
  plugins.lsp.inlayHints = true;

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
      action =
        helpers.mkRaw "require('telescope.builtin').lsp_type_definitions";
    }
    {
      mode = "n";
      key = "gi";
      action = helpers.mkRaw "require('telescope.builtin').lsp_implementations";
    }
  ];
}

