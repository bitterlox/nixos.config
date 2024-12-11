# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }:
let t = lib.types;
in {
  options.runtimeBinaries = lib.options.mkOption {
    type = t.listOf t.package;
    default = [ ];
    example = "[ pkgs.ripgrep ]";
    description = "a list of packages to be added to neovim's $PATH";
  };
}
