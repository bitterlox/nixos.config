# this is akin to a flake-parts top-level module
{ ... }:
{
  flake.homeModules = {
    fzf = import ./fzf.nix;
    bash = import ./bash.nix;
    angel = import ./angel.nix;
  };
}
