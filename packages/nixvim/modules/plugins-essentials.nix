arg@{ config, helpers, lib, options, specialArgs }: {
  imports = [ ./plugins/telescope.nix ./plugins/nvim-cokeline.nix ];
  config = { plugins.web-devicons.enable = true; };
}
