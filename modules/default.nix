{ self, inputs, ... }:
let
  overlay-nvim = prev: final: {
    neovim = inputs.my-nvim.packages.x86_64-linux.default;
  };
in {
  imports = [{
    _module.args = {
      sharedModules = [{ nixpkgs.overlays = [ overlay-nvim ]; }];
    };
  }];
  perSystem = { system, pkgs, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ overlay-nvim ];
    };
  };

  #  flake.nixosModules = { nix = import ./nix.nix; };
}
