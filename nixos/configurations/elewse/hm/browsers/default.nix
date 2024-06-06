{ config, pkgs, lib, ... }: {
  imports = [ ./firefox.nix ];

  # browserpass
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];
}

