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
        username = "angel";
        darwin = inputs.darwin;
        home-manager = inputs.home-manager;
      in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          inputs.nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          (import ./system.nix username self'.packages inputs)
          (import ./home-manager.nix username config.flake.homeModules)

        ];
      }
    );
  };
}
