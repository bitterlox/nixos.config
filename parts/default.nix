# everything in here should be considered a flake-parts "top-level module"
{
  imports = [ ./lib.nix ./packages.nix ./modules.nix ./machines.nix ];
}
