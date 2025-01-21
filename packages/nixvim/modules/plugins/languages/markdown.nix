# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {

  plugins.lsp.servers.efm.enable = true;
  # enable on all files
  plugins.lsp.servers.efm.filetypes = [ "json" ];
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
  # markdown = {
  # {
  #  prefix = "markdownlint",
  #  lintCommand = "markdownlint parsable ${INPUT}",
  #  lintStdin = true,
  #  -- this is vim error format https://vimhelp.org/quickfix.txt.html#error-file-format
  #  -- tested with https://github.com/reviewdog/errorformat (which is used in efm-langserver)
  #  lintFormats = { '%f:%l %m' },
  # }
  # }
  plugins.efmls-configs.enable = true;
  plugins.efmls-configs.setup.markdown.linter = [ "markdownlint" ];
}

