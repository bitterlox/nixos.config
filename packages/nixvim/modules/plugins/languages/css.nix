# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  plugins.lsp.servers.efm.enable = true;
  # enable on all files
  plugins.lsp.servers.efm.filetypes = [ "yaml" ];
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
  # biome should support css i think
  plugins.efmls-configs.setup.css.formatter = [ "stylelint" ];
  plugins.efmls-configs.setup.css.linter = [ "stylelint" ];
}

