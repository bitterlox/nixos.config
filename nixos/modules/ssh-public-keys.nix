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
