# this is akin to a flake-parts top-level module
{ inputs, config, lib, getSystem, moduleWithSystem, privateModules, withSystem
, ... }:
let
  sharedModules = config.flake.nixosModules;
  secretsModule = (import ./modules/secrets.nix inputs.secrets-flake
    inputs.agenix.nixosModules.default sharedModules.lockbox);
in {
  flake.nixosConfigurations = {
    "chani" = withSystem "x86_64-linux"
      (ctx@{ inputs', self', system, pkgs, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          # If you need to pass other parameters,
          # you must use `specialArgs` by uncomment the following line:
          specialArgs = { };
          modules = [{
            # add my own packages
            environment.systemPackages = let p = self'.packages;
            in [ p.nvim-light ];
          }] ++ privateModules ++ [
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
              home-manager.users.angel = { osConfig, ... }: {
                imports = [ config.flake.homeModules.angel ];
                config = {
                  programs.ssh.includes = [ osConfig.lockbox.sshHostsPath ];
                  # This value determines the home Manager release that your
                  # configuration is compatible with. This helps avoid breakage
                  # when a new home Manager release introduces backwards
                  # incompatible changes.
                  #
                  # You can update home Manager without changing this value. See
                  # the home Manager release notes for a list of state version
                  # changes in each release.
                  home.stateVersion = "23.05";
                };
              };
            }
          ];
        });
  };
}
