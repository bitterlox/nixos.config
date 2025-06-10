{ config, pkgs, lib, ... }: {
  imports = [ ./librewolf.nix ];

  # browserpass
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "librewolf" ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [{ id = "fmkadmapgofadopljbjfkapdkoienihi"; }];
  };
}

