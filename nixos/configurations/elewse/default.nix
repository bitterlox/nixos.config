# this is akin to a flake-parts top-level module
{ inputs, config, lib, getSystem, moduleWithSystem, privateModules, withSystem
, ... }:
let
  sharedModules = config.flake.nixosModules;
  secretsModule = (import ./modules/secrets.nix inputs.secrets-flake
    inputs.agenix.nixosModules.default sharedModules.lockbox);
  impermanenceModule = (import ./modules/impermanence.nix
    inputs.impermanence.nixosModules.impermanence);
in {
  flake.nixosConfigurations = {
    "elewse" = withSystem "x86_64-linux" (ctx@{ inputs', system, pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        # If you need to pass other parameters,
        # you must use `specialArgs` by uncomment the following line:
        specialArgs = { };
        modules = [{
          nixpkgs.overlays = [
            (prev: final: {
              neovim-full = inputs'.my-nvim.packages.nvim-full;
              neovim-light = inputs'.my-nvim.packages.nvim-light;
            })
          ];
        }] ++ privateModules ++ [
          inputs.nixos-hardware.nixosModules.framework-16-7040-amd
          inputs.lanzaboote.nixosModules.lanzaboote
          impermanenceModule
          secretsModule
          sharedModules.linux-base
          ./configuration.nix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
            home-manager.users.angel =
              (import ./modules/hm/desktop.nix config.flake.homeModules.angel);
          }
        ];
      });
  };
}
