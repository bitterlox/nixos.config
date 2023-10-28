{ pkgs }: {
  build-machine-secrets = secrets-flake: machine-name:
    import (./secrets.nix) { inherit secrets-flake machine-name; };
  ssh-public-keys = {
      voidbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/JDXLqz8IKnkWZollqDXs93vOgOcnbTSUcPCP0jhug" ;
      sietch = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU46eX72eMVDqIbvsNy6yfsWq8kVx1rnqkyvWyM92m1";
    };
}
