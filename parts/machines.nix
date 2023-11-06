{ inputs, config, lib, getSystem, moduleWithSystem, privateModules, withSystem
, ... }:
let
  ssh-public-keys =
    builtins.trace privateModules config.flake.lib.ssh-public-keys;
in {
  flake.nixosConfigurations = {
    "chani" = withSystem "x86_64-linux" (ctx@{ inputs', system, pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        # If you need to pass other parameters,
        # you must use `specialArgs` by uncomment the following line:
        specialArgs = {
          inherit ssh-public-keys;
        }; # if this is missing it throws an infinite recursion er
        modules = [{ nixpkgs.pkgs = pkgs; }] ++ privateModules ++ [
          # decrypt secrets
          (config.flake.nixosModules.agenix)
          ../modules/linux-base.nix
          ../machines/chani/configuration.nix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
            home-manager.users.angel = import ../chani-angel.nix;
          }
          ../chani-secret.nix
        ];
      });
    "sietch" = withSystem "x86_64-linux" (ctx@{ inputs', pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [{ nixpkgs.pkgs = pkgs; }] ++ privateModules ++ [
          (config.flake.nixosModules.agenix)
          ../modules/linux-base.nix
          ../machines/sietch/configuration.nix
          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # TODO replace ryan with your own username
            home-manager.users.angel = import ../sietch-angel.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      });
  };
}
