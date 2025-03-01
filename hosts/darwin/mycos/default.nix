# this is akin to a flake-parts top-level module
{
  self,
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
            environment.systemPackages =
              let
                p = self'.packages;
              in
              [
                p.nvim-light
                pkgs.kitty
                pkgs.pass
                pkgs.gnupg
              ];
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
                trusted-users = [
                  "@admin"
                  "${user}"
                ];
                substituters = [
                  "https://nix-community.cachix.org"
                  "https://cache.nixos.org"
                ];
                trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
              };

              gc = {
                user = "root";
                automatic = true;
                interval = {
                  Weekday = 0;
                  Hour = 2;
                  Minute = 0;
                };
                options = "--delete-older-than 30d";
              };

              # Turn this on to make command line easier
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
            };
            homebrew = {
              enable = true;
              casks = [
                "protonvpn"
                "proton-drive"
                "kitty"
                "vlc"
                "steam"
                "obsidian"
              ];
              masApps = {
                drafts = 1435957248;
                todoist = 585829637;
              };
              whalebrews = [ ];
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
