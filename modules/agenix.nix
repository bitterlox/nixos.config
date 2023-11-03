agenixModule:
get-secrets-for-machine:
{ inputs, config, lib, ... }@attrs: {
  imports = [ agenixModule ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = get-secrets-for-machine config.networking.hostName;
  };
  options = { };
}
