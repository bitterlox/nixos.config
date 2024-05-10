secrets-flake: agenix-module:
{ config, options, pkgs, lib, ... }: {
  imports = [ agenix-module ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = {
      ssh-private-key = {
        file = secrets-flake.sietch.ssh.private-key;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      borg-passphrase = {
        file = secrets-flake.sietch.borg-passphrase;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      password = {
        file = secrets-flake.sietch.password;
        mode = "600";
        owner = "angel";
        group = "users";
      };
    };
    # WIP fill in stuff in lockbox and add the cleartext stuff alongside
    # not sure if we need to split out the filling of the lockbox to load
    # the agenix module first to decrypt everything
    lockbox = {
      hashedPasswordFilePath = config.age.secrets.password.path;
      passphrasePath = config.age.secrets.borg-passphrase.path;
      sshKeyPath = config.age.secrets.ssh-private-key.path;
      softServeSshPublicUrl = secrets-flake.sietch.soft-serve-ssh-public-url;
    };
  };
  options = {
    lockbox = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example = { mysecret = "superSecretPassword"; };
      description = lib.mdDoc "An attrset of secrets and less secret values";
    };
  };
}
