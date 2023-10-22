let
  get-secrets = secrets-flake: machine:
    import ./get-secrets.nix secrets-flake machine;
in { config, agenix, secrets-flake, lib, ... }: {
  imports = [ agenix ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = get-secrets secrets-flake "chani";
  };
  options = { };
}
