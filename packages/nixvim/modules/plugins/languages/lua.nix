# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  # https://github.com/folke/lazydev.nvim

  plugins.lsp.servers.lua_ls.enable = true;
  plugins.lsp.servers.lua_ls.cmd = [ "lua-language-server" ];
  plugins.lsp.servers.lua_ls.settings = {
    Lua = {
      runtime = {
        ## Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT";
      };
      ##        diagnostics = {
      ##          -- Get the language server to recognize the `vim` global
      ##          globals = { "vim" };
      ##        };
      workspace = {
        ## Make the server aware of Neovim runtime files
        library = "vim.api.nvim_get_runtime_file(''; true)";
        checkThirdParty = false;
      };
      ## Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false; };
    };
  };

  plugins.lsp.servers.efm.enable = true;
  plugins.lsp.servers.efm.cmd = ["efm-langserver"];
  plugins.lsp.servers.efm.filetypes = ["lua"];
  plugins.lsp.servers.efm.settings = {
rootMarkers = [ ".git/" ];
languages = {
  lua = {
      formatCommand = ''${lib.getExe pkgs.stylua} --color never --output-format unified ''${INPUT}'';
      formatStdin = false;
  };
  };

    };

}
