# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {

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

  # manual lua config
  # yaml = {
  #   {
  #     prefix = "yamllint",
  #     lintCommand = "yamllint -s -f parsable ${INPUT}",
  #     lintStdin = true,
  #     -- this is vim error format https://vimhelp.org/quickfix.txt.html#error-file-format
  #     -- tested with https://github.com/reviewdog/errorformat (which is used in efm-langserver)
  #     lintFormats = { '%f:%l:%c: [%t%r] %m' },
  #   }
  # },
  plugins.efmls-configs.enable = true;
  plugins.efmls-configs.languages.yaml.formatter = [ "yq" ];
  plugins.efmls-configs.languages.yaml.linter = [ "yamllint" ];
}

