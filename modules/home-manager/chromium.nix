{ config, pkgs, lib, ... }: {

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [{ id = "fmkadmapgofadopljbjfkapdkoienihi"; }];
  };
}

