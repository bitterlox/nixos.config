# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {

  plugins.lsp.servers.efm.enable = true;
  # enable on all files
  plugins.lsp.servers.efm.filetypes = [ "json" "JSON" ];
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
  plugins.efmls-configs.externallyManagedPackages = [ "fixjson" ];
  runtimeBinaries = [ pkgs.fixjson ];

  # manual lua config
  # json = {
  #   {
  #     prefix = "jsonlint",
  #     lintCommand = "jsonlint -c",
  #     lintStdin = true,
  #     lintFormats = { 'line %l, col %c, found: %m' },
  #   }
  # },
  plugins.efmls-configs.setup.JSON.linter = [ "jsonlint" ];
  plugins.efmls-configs.setup.json.linter = [ "jq" ];
  plugins.efmls-configs.setup.json.formatter = [ "fixjson" ];
}

