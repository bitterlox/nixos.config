{ inputs, config, lib, getSystem, moduleWithSystem, sharedModules, withSystem
, ... }:
let ssh-public-keys = config.flake.lib.ssh-public-keys;
in {

  flake.nixosConfigurations = {
    "chani" = withSystem "x86_64-linux" (ctx@{ inputs', system, pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        # If you need to pass other parameters,
        # you must use `specialArgs` by uncomment the following line:
        specialArgs = {
          inherit  ssh-public-keys;
        }; # if this is missing it throws an infinite recursion er
        modules = [
          { nixpkgs.pkgs = pkgs; }
          (config.flake.nixosModules.agenix)
          # decrypt secrets
          ../modules/linux-base.nix
          (import ../machines/chani.nix ssh-public-keys)
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
    "sietch" = withSystem "x86_64-linux" (ctx@{ inputs', ... }:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # If you need to pass other parameters,
        # you must use `specialArgs` by uncomment the following line:
        #
        specialArgs = {
          inherit inputs ssh-public-keys;
        }; # if this is missing it throws an infinite recursion err
        modules = [
          # add our pkgs with overlays
          #({ pkgs, ... }: { pkgs.overlays = [ overlay-nvim ]; })
          # descrypt secrets
          inputs.agenix.nixosModules.default
          (config.flake.nixosModules.agenix)
          ../modules/linux-base.nix
          ../machines/sietch.nix
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
