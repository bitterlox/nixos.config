agenixModule: get-secrets-for-machine:
{ inputs, config, lib, ... }:
let secrets = get-secrets-for-machine config.networking.hostName;
in {
  imports = [ agenixModule ];
  config = { # maybe put this into separate private module
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = secrets.agenix;
    soft-serve.sshPublicUrl = secrets.plaintext.soft-serve-ssh-public-url;
  };
  options = { };
}
