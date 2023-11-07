agenixModule: get-secrets-for-machine:
{ inputs, config, lib, ... }: {
  imports = [ agenixModule ];
  config = { # maybe put this into separate private module
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = get-secrets-for-machine config.networking.hostName;
  };
  options = { };
}
