# this is a nixvim module
rgs@{ config, helpers, lib, options, pkgs, ... }: {

  # lsp configuration #

  plugins.lsp.servers.rust_analyzer.enable = true;
  plugins.lsp.servers.rust_analyzer.installRustc = true;
  plugins.lsp.servers.rust_analyzer.installCargo = true;

  # https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
  plugins.lsp.servers.rust_analyzer.settings = {
    rust_analyzer = { checkOnSave = { command = "clippy"; }; };
  };
}
