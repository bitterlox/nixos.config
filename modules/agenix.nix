secrets:
{ config, agenix, secrets-flake, lib, ... }: {
  imports = [ agenix ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = lib.debug.traceSeq secrets secrets;
  };
  options = { };
}
