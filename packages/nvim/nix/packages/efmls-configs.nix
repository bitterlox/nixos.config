{ pkgs, src }:
pkgs.vimUtils.buildVimPlugin {
  name = "efmls-configs-nvim";
  inherit src;
}
