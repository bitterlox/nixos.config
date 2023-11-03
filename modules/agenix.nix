{ inputs, config, lib, ... }: let 
  common = (import ../common { inherit lib; });
  get-secrets-for-machine = common.build-machine-secrets inputs.secrets-flake;
in {
  imports = [ ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = get-secrets-for-machine config.networking.hostName;
  };
  options = { };
}
