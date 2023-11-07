# this is akin to a flake-parts top-level module
{ ... }: {
  flake.lib = {
    build-machine-secrets = secrets-flake: machine-name:
      import (../lib/secrets.nix) { inherit secrets-flake machine-name; };
  };
}
