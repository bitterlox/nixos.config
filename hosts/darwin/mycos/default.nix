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
        homeModules = config.flake.homeModules;
        ownPackages = self'.packages;
      in
      darwin.lib.darwinSystem {
        inherit system;
        # can avoid passing modules as functions...
        specialArgs = inputs;
        modules = [
          # entrypoint for system config
          {
            imports = [
              (import ./system username inputs)
              home-manager.darwinModules.home-manager
            ];
            environment.systemPackages = [ ownPackages.nvim-full ];
          }
          # entrypoint for home manager config
          {
            home-manager.useGlobalPkgs = true;
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
            home-manager.users.angel = {
              imports = [
                homeModules.fzf
                homeModules.tmux
                homeModules.bash
                homeModules.ghostty
                (import ./home-manager username)
                inputs.mac-app-util.homeManagerModules.default
              ];
            };
          }
        ];
      }
    );
  };
}
