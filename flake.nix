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
    ## nixpkgs ##
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    ## home-manager ##
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    ## secrets ##
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    secrets-flake.url = "git+ssh://git.bittervoid.io:23231/secrets-flake";
    #secrets-flake.url = "git+file:///home/angel/secrets-flake";

    # DX - utils #
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";

    ## laptop stuff ##
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-stable";

    hyprpaper.url = "github:hyprwm/hyprpaper";
    hyprpaper.inputs.nixpkgs.follows = "nixpkgs-stable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    ## misc coming from nvim-config-flake ##

    efmls-configs = {
      url = "github:creativenull/efmls-configs-nvim";
      flake = false;
    };
    # themes i like: melange, adwaita, caret, sonokai is sort of like melange
    sonokai-theme = {
      url = "github:sainnhe/sonokai";
      flake = false;
    };
    adwaita-theme = {
      url = "github:Mofiqul/adwaita.nvim";
      flake = false;
    };
    citruszest-theme = {
      url = "github:zootedb0t/citruszest.nvim";
      flake = false;
    };
    caret-theme = {
      url = "github:projekt0n/caret.nvim";
      flake = false;
    };
    melange-theme = {
      url = "github:savq/melange-nvim";
      flake = false;
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({ flake-parts-lib, ... }: {
      imports = [ ./lib ./nixos ./hm ./devshells ./packages ];
    });
}

