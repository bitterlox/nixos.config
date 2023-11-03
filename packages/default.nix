{ self, inputs, config, lib, ... }: {
  #imports = [{
  #  _module.args = {
  #    sharedModules = [{ nixpkgs.overlays = [ overlay-nvim ]; }];
  #  };
  #}];
  perSystem = { system, pkgs, ... }:
    let
      overlay-my-nvim = prev: final: {
        neovim = inputs.my-nvim.packages.${system}.default;
      };

    in {
      _module.args.pkgs = lib.debug.traceSeqN 2 config.flake (import inputs.nixpkgs {
        inherit system;
        overlays = [ overlay-my-nvim ];
      });
    };

  systems = [ "x86_64-linux" "aarch64-darwin" ];
}
