# this is akin to a flake-parts top-level module
{ inputs, config, ... }: {
  config = {
    flake.nixosModules = {
      linux-base = ./linux-base.nix;
      lockbox = ./lockbox.nix;
    };
    _module.args.privateModules = [ ./ssh-public-keys.nix ];
  };
}
