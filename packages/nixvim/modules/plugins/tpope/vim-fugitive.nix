# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  # git client
  plugins.fugitive.enable = true;

  keymaps = [{
    mode = "n";
    key = "<leader>gs";
    action = helpers.mkRaw "vim.cmd.Git";
  }];
}
