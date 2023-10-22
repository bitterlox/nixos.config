{ config, agenix, secrets-flake, lib, ... }: {
  imports = [ agenix ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets.ssh-private-key = {
      file = secrets-flake.sihaya.secret1;
      mode = "600";
      owner = "angel";
      group = "users";
    };
  };
  options = { };
}
