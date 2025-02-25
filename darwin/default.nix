# this is akin to a flake-parts top-level module
{
  inputs,
  config,
  lib,
  getSystem,
  moduleWithSystem,
  privateModules,
  withSystem,
  ...
}:
let
  sharedModules = config.flake.nixosModules;
  secretsModule = (
    import ./secrets.nix inputs.secrets-flake inputs.agenix.nixosModules.default sharedModules.lockbox
  );
  impermanenceModule = (import ./impermanence.nix inputs.impermanence.nixosModules.impermanence);
in
{
  flake.darwinConfigurations = {
    "mycos" = withSystem "aarch64-darwin" (
      ctx@{
        inputs',
        self',
        system,
        pkgs,
        ...
      }:
      let
        user = "angel";
        darwin = inputs.darwin;
        home-manager = inputs.home-manager;
      in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew 
          {
            system.stateVersion = 6;
            environment.systemPackages = let p = self'.packages; in [ p.nvim-light pkgs.kitty pkgs.pass pkgs.gnupg ];
            system.defaults = {
              NSGlobalDomain = {
                InitialKeyRepeat = 15;
                KeyRepeat = 1;
                NSAutomaticPeriodSubstitutionEnabled = false;
              };
            };
            nix = {
                package = pkgs.nix;
                configureBuildUsers = true;
            
                settings = {
                  trusted-users = [ "@admin" "${user}" ];
                  substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
                  trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
                };
            
                gc = {
                  user = "root";
                  automatic = true;
                  interval = { Weekday = 0; Hour = 2; Minute = 0; };
                  options = "--delete-older-than 30d";
                };
            
                # Turn this on to make command line easier
                extraOptions = ''
                  experimental-features = nix-command flakes
                '';
              };
            homebrew = {
              enable = true;
              casks = [ "protonvpn" "proton-drive" "kitty" "vlc" "steam" "obsidian"];
              masApps = {
                drafts = 1435957248;
                todoist = 585829637;
              };
              whalebrews = [];
              onActivation = {
                autoUpdate = true;
                cleanup = "uninstall";
                upgrade = true;
              };
            };
            nix-homebrew = {
              inherit user;
              enable = true;
              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              };
              mutableTaps = false;
              autoMigrate = true;
            };
          }
        ];
      }
    );
  };

}
# flake.nixosConfigurations = {
#   "elewse" = withSystem "x86_64-linux"
#     (ctx@{ inputs', self', system, pkgs, ... }:
#      let unstable-pkgs = import inputs.nixpkgs { inherit system; };
#      in inputs.nixpkgs-stable.lib.nixosSystem {
#      inherit system;
# # If you need to pass other parameters,
# # you must use `specialArgs` by uncomment the following line:
#      specialArgs = { };
#      modules = [
#      {
# # this system uses nixpkgs-stable
#      nixpkgs.pkgs = (import inputs.nixpkgs-stable {
#          localSystem = system;
#          config.allowUnfree = true;
#          });
#      }
#      {
# # add my own packages
#      programs.hyprland.package = inputs'.hyprland.packages.hyprland;
#      environment.systemPackages = let p = self'.packages;
#      in [
#      p.nvim-full
#        inputs'.hyprpaper.packages.default
#        inputs'.rose-pine-hyprcursor.packages.default
#      ];
#      environment.pathsToLink = [ "/share/icons" ];
#      }
#      ] ++ privateModules ++ [
#        inputs.nixos-hardware.nixosModules.framework-16-7040-amd
#          inputs.lanzaboote.nixosModules.lanzaboote
#          impermanenceModule
#          secretsModule
#          sharedModules.linux-base
#          (import ./configuration.nix config.flake.lib)
# # make home-manager as a module of nixos
# # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
#          inputs.home-manager-stable.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;

# # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
#            home-manager.users.angel = { ... }: {
#              imports = [
#                (import ./hm/desktop.nix config.flake.homeModules.angel
#                 inputs.impermanence.nixosModules.home-manager.impermanence)
#              ];
#              config = { };
#            };
#          }
#      ];
#      });

# };
