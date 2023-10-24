secrets:
{ config, agenix, lib, ... }: {
  imports = [ agenix ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = secrets;
  };
  options = { };
}
