agenixModule: get-secrets-for-machine:
{ inputs, config, lib, ... }:
let secrets = get-secrets-for-machine config.networking.hostName;
in {
  imports = [ agenixModule ];
  config = { # maybe put this into separate private module
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = secrets.agenix;
    plaintext-secrets = secrets.plaintext;
  };
  options = {
    plaintext-secrets = lib.mkOption {
      type = lib.types.anything;
      default = { };
      example = "{}";
      description = lib.mdDoc "Anything goes in here";
    };
  };
}
