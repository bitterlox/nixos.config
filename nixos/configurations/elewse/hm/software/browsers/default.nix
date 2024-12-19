{ config, pkgs, lib, ... }: {
  imports = [ ./firefox.nix ];

  # browserpass
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [{ id = "fmkadmapgofadopljbjfkapdkoienihi"; }];
  };
}

