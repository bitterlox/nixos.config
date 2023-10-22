machine_name: let
  get-secrets = secrets-flake: 
    import ./get-secrets.nix secrets-flake machine_name;
in { config, agenix, secrets-flake, lib, ... }: {
  imports = [ agenix ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = get-secrets secrets-flake;
  };
  options = { };
}
