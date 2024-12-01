# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  # lsp configuration #

  plugins.lsp.servers.bashls.enable = true;
  plugins.lsp.servers.bashls.rootDir =
    "require('lspconfig.util').find_git_ancestor";

  # https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
  plugins.lsp.servers.bashls.settings = {
    # TODO: look into setting up local explainshell to hook up with this
    explainShellEndpoint = "";
    includeAllWorkspaceSymbols = true;

    shellCheckPath = lib.getExe pkgs.shellcheck;

    shfmt = {
      path = lib.getExe pkgs.shfmt;
      languageDialect = "auto";
      funcNextLine = true;
      caseIndent = true;
      simplyfiCode = true;
      spaceRedirects = true;
    };
  };
}
