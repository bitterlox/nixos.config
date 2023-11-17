# this is akin to a flake-parts top-level module
{ inputs, config, lib, getSystem, moduleWithSystem, privateModules, withSystem
, ... }:
let
  nixosModules = config.flake.nixosModules;
  nixosBaseModules = with nixosModules; [ agenix linux-base ];
in {
  flake.nixosConfigurations = {
    "chani" = withSystem "x86_64-linux" (ctx@{ inputs', system, pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        # If you need to pass other parameters,
        # you must use `specialArgs` by uncomment the following line:
        specialArgs = { };
        modules = [{ nixpkgs.pkgs = pkgs; }] ++ privateModules
          ++ nixosBaseModules ++ [
            ./configuration.nix
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
              home-manager.users.angel = import config.flake.homeModules.angel;
            }
            # use secrets
            ({ config, ... }: {
              config.home-manager.users.angel = {
                programs.ssh = {
                  enable = true;
                  matchBlocks = {
                    "*" = {
                      serverAliveInterval = 120;
                      identityFile = config.age.secrets.ssh-private-key.path;
                    };
                  };
                };
              };
            })
          ];
      });
  };
}
