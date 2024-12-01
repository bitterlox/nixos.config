# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

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
}
