# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  imports = [ ./set.nix ./remaps.nix ./diagnostics.nix ];
}
