angelBaseModule:
{ lib, config, options, pkgs, osConfig, ... }:
let
  overrides = {
    eww = pkgs.eww.overrideAttrs (oldAttrs: {
      cargoBuildFlags = oldAttrs.cargoBuildFlags ++ [ "--features=wayland" ];
      buildInputs = [ pkgs.gtk-layer-shell ];
    });
    nerdfonts = pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "SourceCodePro"
        "Hasklig"
        "NerdFontsSymbolsOnly"
      ];
    };
  };
in {
  imports = [ angelBaseModule ./compositor ./browsers ];
  config = {

    home.packages = let
      overriden = [ overrides.nerdfonts ];
      vanilla = with pkgs; [
        wl-clipboard
        shotman
        libnotify
        obsidian
        popcorntime
        font-manager
      ];
    in overriden ++ vanilla;
    home.extraOutputsToInstall = [ "share" ];

    fonts.fontconfig.enable = true;

    ## PROGRAMS ##
    programs.kitty = {
      enable = true;
      keybindings = { };
    };

    programs.password-store.enable = true;
    programs.password-store.settings = {
      PASSWORD_STORE_DIR = "/home/angel/.password-store";
    };

    programs.gpg.enable = true;
    programs.ssh.includes = [ osConfig.lockbox.sshHostsPath ];

    ## SERVICES ##
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    services.mako.enable = true;
    services.cliphist.enable = true;

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
