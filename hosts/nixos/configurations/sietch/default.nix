# this is akin to a flake-parts top-level module
{ inputs, config, lib, getSystem, moduleWithSystem, privateModules, withSystem
, ... }:
let
  sharedModules = config.flake.nixosModules;
  secretsModule = (import ./modules/secrets.nix inputs.secrets-flake
    inputs.agenix.nixosModules.default sharedModules.lockbox);
in {
  flake.nixosConfigurations = {
    "sietch" = withSystem "x86_64-linux"
      (ctx@{ inputs', self', system, pkgs, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = let p = self'.packages;
          in [{
            # add my own packages
            environment.systemPackages = [ p.nvim-light ];
          }] ++ privateModules ++ [
            #shared-modules.agenix
            secretsModule
            sharedModules.linux-base
            ./modules/soft-serve
            (import ./configuration.nix config.flake.lib)
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
              home-manager.users.root = { osConfig, ... }: {
                imports = [ config.flake.homeModules.angel ];
                config = {
                  home.username = lib.mkForce "root";
                  home.homeDirectory = lib.mkForce "/root";
                  programs.ssh.enable = true;
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

