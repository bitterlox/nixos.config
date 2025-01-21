# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {
  plugins.undotree.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = helpers.mkRaw "vim.cmd.UndotreeToggle";
    }
  ];
}
