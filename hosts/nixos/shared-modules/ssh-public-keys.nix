{ lib, ... }: {
  imports = [ ];
  config = {
    sshPubKeys = {
      voidbook =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/JDXLqz8IKnkWZollqDXs93vOgOcnbTSUcPCP0jhug";
      sietch =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU46eX72eMVDqIbvsNy6yfsWq8kVx1rnqkyvWyM92m1";
      chani =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxYtqQcofv/r//CrgARfvJpFgOwHntC1b2dlm18VIlA";
      elewse =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSJyQLqQGKlEzRwFNNH2W0RfEfn/3dvL9GH+CZw+bQP";
      iphone =
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqcHfgGYD2AKWEzW3ngzX67T0cMX3wmaQrjCN6tl00oLbPXtkWJjhrwa203T6692DE1BsbzsvF70x2gSkt33OtNuq95gS2BZ5IXSdgVVaMx2AG69IES/Gj8b5aaCFt3q3ms2RNk9yUwCVeYRv1HcNCXIvGhogTb2eEPicdkVGmQEbh1MlhaSf7/HJKUYf/uXP8DBDZg7Hr6SjpnNrKSwOB/ZmLB4h9eGui2x7GBg/CRvdW0wEnzQ2aGfxqf1nhPz5R0wYXk3zOLelytYKGJwr58qjilCgD/NLXhrCVxgZKkqFzQnWdYrOfqTCSrxfYbdAXbYO+zlZCVZsrZ9DLwgThAYX+A0staSALsXxPtBrNq4pCDRn0fMZibHGIn0MWUv+NefrFVbHds9U42iL+qjm7t11y6aFMMPzIoSlAkp0XRmJPilVlLubaRbnePY1lUpR3lBgXQAxfFC0qF+2M0AiM4gffPLM7lpodG9ak2BPJETF/A218Zr08TIeDbtPBkVhKZu8EPI7nJShHiXDmOdniSsf41U11DsNAGqXYD9wBFTghB4oTK+jZrtMjrTfc+IYCiO+IkHUZWNugXe2PauDJF+szl29dTCKzuTWhIBJ2hH7LdEBEdBpO1BijKREtdOoHh0x7fud0qBBoGHY+3e4xYTCS1ZMKiKN9KbyxMwoyyw==";
    };
  };
  options = {
    sshPubKeys = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example = { foo = "ssh-ed25519 AAAAC....."; };
      description = lib.mdDoc "An attrSet of various ssh public keys";
    };
  };
}
