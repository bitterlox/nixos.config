{ pkgs }: {
  build-machine-secrets = secrets-flake: machine-name:
    import (./secrets.nix) { inherit secrets-flake machine-name; };
}
