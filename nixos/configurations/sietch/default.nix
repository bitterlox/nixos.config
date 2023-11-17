# this is akin to a flake-parts top-level module
{ inputs, config, lib, getSystem, moduleWithSystem, privateModules, withSystem
, ... }:
let
  nixosModules = config.flake.nixosModules;
  nixosBaseModules = with nixosModules; [ agenix linux-base ];
in {
  flake.nixosConfigurations = {
    "sietch" = withSystem "x86_64-linux" (ctx@{ inputs', system, pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [{ nixpkgs.pkgs = pkgs; }] ++ privateModules
          ++ nixosBaseModules ++ [
            nixosModules.soft-serve
            (import ./configuration.nix config.flake.lib)
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # TODO replace ryan with your own username
              home-manager.users.angel = import config.flake.homeModules.angel;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
          ];
      });
  };
}

