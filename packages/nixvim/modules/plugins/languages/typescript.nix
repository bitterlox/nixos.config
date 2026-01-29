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

  # todo: setup for deno project
  # https://docs.deno.com/runtime/reference/lsp_integration/
  # can detect deno projects through looking up if there's a deno.json
  # in the root dir

  plugins.lsp.servers.ts_ls.enable = true;

  plugins.lsp.servers.ts_ls.settings = {
    javascript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true;
        includeInlayFunctionLikeReturnTypeHints = true;
        includeInlayFunctionParameterTypeHints = true;
        includeInlayParameterNameHints = "all"; # 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true;
        includeInlayPropertyDeclarationTypeHints = true;
        includeInlayVariableTypeHints = false;
      };
    };

    typescript = {
      inlayHints = {
        includeInlayEnumMemberValueHints = true;
        includeInlayFunctionLikeReturnTypeHints = true;
        includeInlayFunctionParameterTypeHints = true;
        includeInlayParameterNameHints = "all"; # 'none' | 'literals' | 'all';
        includeInlayParameterNameHintsWhenArgumentMatchesName = true;
        includeInlayPropertyDeclarationTypeHints = true;
        includeInlayVariableTypeHints = false;
      };
    };
  };

  plugins.lsp.servers.efm.enable = true;
  # enable on all files
  plugins.lsp.servers.efm.filetypes = [
    "typescript"
    "typescriptreact"
    "vue"
  ];
  plugins.lsp.servers.efm.extraOptions = {
    init_options = {
      documentFormatting = true;
      documentRangeFormatting = true;
      hover = true;
      documentSymbol = true;
      codeAction = true;
      completion = true;
    };
  };

  plugins.efmls-configs.enable = true;
  plugins.efmls-configs.externallyManagedPackages = [ "deno_fmt" ];
  extraPackages = [ pkgs.deno ];

  plugins.efmls-configs.languages.typescript.linter = [ "eslint" ];
  plugins.efmls-configs.languages.typescript.formatter = [ "deno_fmt" ];
  # plugins.efmls-configs.languages.typescriptreact.linter = [ "eslint" ];
  plugins.efmls-configs.languages.typescriptreact.formatter = [ "deno_fmt" ];
}
