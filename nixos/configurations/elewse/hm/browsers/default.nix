{ config, pkgs, lib, ... }: {
  imports = [ ./firefox.nix ];

  home.packages = [ pkgs.ungoogled-chromium ];

  # browserpass
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];
}

