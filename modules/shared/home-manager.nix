# this is akin to a flake-parts top-level module
{inputs, ...}: 
            inputs.home-manager-stable.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
              home-manager.users.angel = { ... }: {
                imports = [
                ];
                config = { };
              };
            }

