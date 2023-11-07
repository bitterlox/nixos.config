# this is akin to a flake-parts top-level module
{ inputs, config, ... }:
let
  get-secrets-for-machine =
    config.flake.lib.build-machine-secrets inputs.secrets-flake;
in {
  config = {
    flake.nixosModules = {
      agenix = (import ./nixos/agenix.nix inputs.agenix.nixosModules.default
        get-secrets-for-machine);
      linux-base = ./nixos/linux-base.nix;
      soft-serve = ./nixos/soft-serve;
    };
    _module.args.privateModules = [ ./nixos/ssh-public-keys.nix ];
  };
}
