# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {
  plugins.undotree.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = lib.nixvim.mkRaw "vim.cmd.UndotreeToggle";
    }
  ];
}
