# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  plugins.lsp.servers.gopls.enable = true;

  plugins.lsp.servers.gopls.cmd = [ "gopls" "serve" ];
  plugins.lsp.servers.gopls.filetypes = [ "go" "gomod" ];
  # plugins.lsp.servers.gopls.onAttach.function = ''
  #   if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
  #         vim.print("tt") 
  #           end

  # '';
  plugins.lsp.servers.gopls.rootDir = helpers.mkRaw
    "require('lspconfig.util').root_pattern('go.work', 'go.mod', '.git')";
  plugins.lsp.servers.gopls.settings = {
    gopls = {
      # general settings
      # https://github.com/golang/tools/blob/master/gopls/doc/settings.md
      gofumpt = true;
      analyses = {
        # analyzers settings
        # https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        fieldalignment = true;
        nilness = true;
        shadow = true;
        unusedparams = true;
        unusedwrite = true;
        useany = true;
        unusedvariable = true;
      };
      # use linters from staticcheck.io
      staticcheck = true;
      # diagnostics reported by the gc_details command
      annotations = {
        bounds = true;
        escape = true;
        inline = true;
        nil = true;
      };
      hints = {
        # inlayhints settings
        # https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
        assignVariableTypes = true;
        compositeLiteralFields = true;
        compositeLiteralTypes = true;
        constantValues = true;
        functionTypeParameters = true;
        parameterNames = true;
        rangeVariableTypes = true;
      };
    };
  };
}
