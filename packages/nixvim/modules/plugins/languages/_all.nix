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

  plugins.otter.enable = true;
  plugins.otter.settings = {
    buffers.set_filetype = true;
    lsp.diagnostic_update_events = [
      "BufWritePost"
      "InsertLeave"
      "TextChanged"
    ];
    verbose = {
      no_code_found = true;
    };
  };

  imports = [
    # common languages
    ./_common.nix

    # golang support
    ./go.nix

    # zig support
    ./zig.nix

    # typescript support
    ./typescript.nix

    # css support
    ./css.nix

    # bash support
    ./bash.nix

    # lua support
    ./lua.nix

    # nix support
    ./rust.nix

    # nix support
    ./nix.nix
  ];
}
