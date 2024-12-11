# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  plugins.undotree.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>u";
      action = helpers.mkRaw "vim.cmd.UndotreeToggle";
    }
  ];
}
