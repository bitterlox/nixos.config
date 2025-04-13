# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, ... }: {

  imports = [ ./nix.nix ./json.nix ./yaml.nix ./markdown.nix ];

  # lisps
  #   either https://github.com/bhurlow/vim-parinfer?tab=readme-ov-file
  #   or https://github.com/gpanders/nvim-parinfer

}

