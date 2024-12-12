# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  # lsp configuration #

  plugins.lsp.servers.bashls.enable = true;
  plugins.lsp.servers.bashls.rootDir =
    "require('lspconfig.util').find_git_ancestor";

  # https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
  plugins.lsp.servers.bashls.settings = {
    # TODO: look into setting up local explainshell to hook up with this
    # explainShellEndpoint = "";
    includeAllWorkspaceSymbols = true;

    shellCheckPath = lib.getExe pkgs.shellcheck;

    shfmt = {
      # all formatting comes from efm
      path = "";
      languageDialect = "auto";
      funcNextLine = true;
      caseIndent = true;
      simplyfiCode = true;
      spaceRedirects = true;
    };
  };

  runtimeBinaries = [ pkgs.shellharden pkgs.beautysh pkgs.shfmt ];

  plugins.lsp.servers.efm.enable = true;
  plugins.lsp.servers.efm.filetypes = [ "sh" ];
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
  plugins.lsp.servers.efm.settings = {
    rootMarkers = [ ".git/" ];
    languages = { };
  };

  # manual lua config
  # sh = {
  #   {
  #     formatCommand = "shellharden --transform ${INPUT}",
  #     formatStdin = false,
  #   },
  #   require('efmls-configs.formatters.shfmt'),
  # },
  plugins.efmls-configs.enable = true;
  plugins.efmls-configs.setup.sh.formatter =
    [ "shfmt" "beautysh" "shellharden" ];
}
