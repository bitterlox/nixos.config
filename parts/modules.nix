{ inputs, config, lib, ... }@attrs:
let
  get-secrets-for-machine =
    config.flake.lib.build-machine-secrets inputs.secrets-flake;
in {
  config = {
    flake.nixosModules = {
      agenix = (import ../modules/agenix.nix inputs.agenix.nixosModules.default
        get-secrets-for-machine);
    };
    _module.args.privateModules = [ ../modules/ssh-public-keys.nix ];
  };
}
