# this is akin to a flake-parts top-level module
{ ... }:
{
  flake.homeModules = {
    fzf = import ./fzf.nix;
    tmux = import ./tmux.nix;
    bash = import ./bash.nix;
    angel = import ./angel.nix;
    chromium = import ./chromium.nix;
    firefox = import ./firefox.nix;
  };
}
