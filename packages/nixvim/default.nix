# this is a flake-parts module
{ ... }: {
  imports = [ ./stable.nix ./unstable.nix ];
}
