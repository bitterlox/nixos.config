# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {
  # git client
  plugins.fugitive.enable = true;

  keymaps = [{
    mode = "n";
    key = "<leader>gs";
    action = lib.nixvim.mkRaw "vim.cmd.Git";
  }];
}
