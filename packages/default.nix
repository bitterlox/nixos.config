# this is akin to a flake-parts top-level module
{ self, inputs, config, lib, ... }: {
  #imports = [{
  #  _module.args = {
  #    sharedModules = [{ nixpkgs.overlays = [ overlay-nvim ]; }];
  #  };
  #}];
  perSystem = { inputs', system, pkgs, ... }:
    let
      overlay-my-nvim = prev: final: {
        neovim-full = inputs'.my-nvim.packages.nvim-full;
        neovim-light = inputs'.my-nvim.packages.nvim-light;
      };
    in {
      # shadow the `pkgs` arg in perSystem with a new pkgs to which we add our overlays
      config._module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ overlay-my-nvim ];
      };
    };
  systems = [ "x86_64-linux" "aarch64-darwin" ];
}
