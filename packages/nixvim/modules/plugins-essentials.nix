# this is a nixvim module
args@{ config, helpers, lib, options, specialArgs }: {
  imports = [
    ./plugins/telescope.nix
    ./plugins/nvim-cokeline.nix
    ./plugins/tmux-nvim.nix
  ];
  config = { plugins.web-devicons.enable = true; };
}
