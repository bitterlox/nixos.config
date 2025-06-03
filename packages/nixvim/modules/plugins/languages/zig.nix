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

  extraPackages = [ pkgs.zig ];

  plugins.zig.enable = true;
  plugins.zig.settings.fmt_autosave = 1;

  # lsp configuration #

  plugins.lsp.servers.zls.enable = true;

  plugins.lsp.servers.zls.filetypes = [ "zig" ];
  plugins.lsp.servers.zls.onAttach.function = ''
    vim.lsp.inlay_hint.enable(false)
  '';

  plugins.neotest.adapters.zig.enable = true;
}
