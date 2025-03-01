secrets-flake: agenix-module: lockbox-module:
{ config, options, pkgs, lib, ... }: {
  imports = [ lockbox-module agenix-module ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = {
      ssh-private-key = {
        file = secrets-flake.sietch.ssh.private-key;
        mode = "600";
        owner = "root";
        group = "root";
      };
      borg-passphrase = {
        file = secrets-flake.sietch.borg-passphrase;
        mode = "600";
        owner = "root";
        group = "root";
      };
      password = {
        file = secrets-flake.sietch.password;
        mode = "600";
        owner = "root";
        group = "root";
      };
      ssh-hosts = {
        file = secrets-flake.common.ssh-hosts;
        mode = "600";
        owner = "root";
        group = "root";
      };
    };
    lockbox = {
      hashedPasswordFilePath = config.age.secrets.password.path;
      borgPassphrasePath = config.age.secrets.borg-passphrase.path;
      sshHostsPath = config.age.secrets.ssh-hosts.path;
      sshKeyPath = config.age.secrets.ssh-private-key.path;
      softServeSshPublicUrl = secrets-flake.sietch.soft-serve-ssh-public-url;
      sshPubKeys = {
        inherit (secrets-flake.common.sshPubKeys) voidbook iphone;
        chani = secrets-flake.chani.ssh.public-key;
        elewse = secrets-flake.elewse.ssh.public-key;
      };
      inherit (secrets-flake.sietch) borg-repo-urls;
    };
  };
}
