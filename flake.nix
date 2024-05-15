{
  description = "system configuration flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.nixos.org/" ];

    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    my-nvim.url = "github:bitterlox/nvim-config-flake";
    my-nvim.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    devenv.url = "github:cachix/devenv";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    #secrets-flake.url = "git+ssh://git.bittervoid.io:23231/secrets-flake";
    secrets-flake.url = "git+ssh://git.bittervoid.io:23231/secrets-flake";
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({ flake-parts-lib, ... }: {
      imports = [ ./lib ./packages ./nixos ./hm ./devshells ];
    });
}

