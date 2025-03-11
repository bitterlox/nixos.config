# this is akin to a flake-parts top-level module
{ ... }:
{
  flake.darwinModules = {
    lockbox = import ./lockbox.nix;
  };
}
