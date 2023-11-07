{ inputs, ... }: {
  flake.homeConfigurations.angel =
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
      home-manager.users.angel = import ./home.nix;
    };
}
