angelBaseModule:
{ lib, config, options, pkgs, ... }:
let
  overrides = {
    eww = pkgs.eww.overrideAttrs (oldAttrs: {
      cargoBuildFlags = oldAttrs.cargoBuildFlags ++ [ "--features=wayland" ];
      buildInputs = [ pkgs.gtk-layer-shell ];
    });
  };
in {
  imports = [ angelBaseModule ./compositor.nix ];
  config = {

    home.packages = let
      overriden = [ ];
      vanilla = with pkgs; [ wl-clipboard shotman libnotify nerdfonts ];
    in overriden ++ vanilla;

    services.cliphist.enable = true;
    # rename eww subdir to something like widgets/bar and put stuff down below
    # into it, abstracting it away into a module

    fonts.fontconfig.enable = true;

    services.mako.enable = true;

    programs.kitty = {
      enable = true;
      keybindings = { };
    };

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.11";
  };
}
