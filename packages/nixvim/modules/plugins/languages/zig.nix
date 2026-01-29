# this is a nixvim module
args@{
  config,
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
    vim.lsp.inlay_hint.enable(true)
  '';

  plugins.lsp.servers.zls.settings = {
    zls = {
      zig_exe_path = lib.getExe pkgs.zig;
    };
  };

  plugins.neotest.adapters.zig.enable = true;
}
