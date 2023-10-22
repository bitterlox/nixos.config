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
  # This is the standard format for flake.nix.
  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nvim = {
      url = "github:bitterlox/nvim-config-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets-flake = {
      type = "path";
      path = "/etc/nixos/secrets-flake";
    };
  };

  # `outputs` are all the build result of the flake.
  #
  # A flake can have many use cases and different types of outputs.
  # 
  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself(self-reference)
  # 
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs =
    { self, nixpkgs, home-manager, my-nvim, agenix, secrets-flake, ... }@inputs:
    let
      overlay-nvim = prev: final: {
        neovim = my-nvim.packages.x86_64-linux.default;
      };

      ssh-keys = let
        imported-ssh-keys = if (builtins.pathExists ./ssh-keys.nix) then
          (import ./ssh-keys.nix)
        else
          { };
      in nixpkgs.lib.recursiveUpdate { } imported-ssh-keys;

      # we shadow pkgs here and add our overlays
      #    pkgs = import nixpkgs {
      #        system = "x86_64-linux";
      #        overlays = [ overlay-nvim ];
      #     };
    in {
      nixosConfigurations = {
        "sihaya" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # If you need to pass other parameters,
          # you must use `specialArgs` by uncomment the following line:
          #
          specialArgs = {
            agenix = agenix.nixosModules.default;
            inherit secrets-flake;
          }; # pass custom arguments into all sub module.
          modules = [
            # add our nixpkgs with overlays
            ({ pkgs, ... }: { nixpkgs.overlays = [ overlay-nvim ]; })
            ./agenix.nix
            #            {
            #              imports = [ agenix.homeManagerModules.default ];
            #              config = {
            #                age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            #                age.secrets.secret1.file = secrets-flake.sihaya.secret1;
            #              };
            #            }
            # Import the configuration.nix here, so that the
            # old configuration file can still take effect.
            # Note: configuration.nix itself is also a Nix Module,
            ./sihaya-configuration.nix
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
              home-manager.users.angel =
                import ./sihaya-angel.nix;
            }
            ./sihaya-secret.nix
            #./trace-test.nix
            #            (attrs: {
            #              config = builtins.trace
            #                (attrs.lib.debug.traceVal (builtins.attrNames attrs.config)) { };
            #            })
          ];
        };
        "maker" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # If you need to pass other parameters,
          # you must use `specialArgs` by uncomment the following line:
          #
          # specialArgs = {...}  # pass custom arguments into all sub module.
          modules = [
            # Import the configuration.nix here, so that the
            # old configuration file can still take effect.
            # Note: configuration.nix itself is also a Nix Module,
            ./maker-configuration.nix
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # TODO replace ryan with your own username
              home-manager.users.angel =
                import ./maker-angel.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
          ];
        };
      };
    };
}

