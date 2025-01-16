# this is a nixvim module
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  specialArgs,
}:
{

  runtimeBinaries = [ pkgs.zig ];

  plugins.zig.enable = true;
  plugins.zig.settings.fmt_autosave = 1;

  # lsp configuration #

  plugins.lsp.servers.zls.enable = true;

  # plugins.lsp.servers.zls.cmd = [
  #   "gopls"
  #   "serve"
  # ];
  plugins.lsp.servers.zls.filetypes = [ "zig" ];

  plugins.neotest.adapters.zig.enable = true;
}
