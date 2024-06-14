secrets-flake: agenix-module: lockbox-module:
{ config, options, pkgs, lib, ... }: {
  imports = [ lockbox-module agenix-module ];
  config = {
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets = {
      ssh-private-key = {
        file = secrets-flake.elewse.ssh.private-key;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      ssh-public-key = {
        file = secrets-flake.elewse.ssh.public-key;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      password = {
        file = secrets-flake.elewse.password;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      ssh-hosts = {
        file = secrets-flake.common.ssh-hosts;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      borg-passphrase = {
        file = secrets-flake.elewse.borg-passphrase;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      backups-ssh-privkey = {
        file = secrets-flake.elewse.backups-ssh-privkey;
        mode = "600";
        owner = "angel";
        group = "users";
      };
    };
    lockbox = {
      hashedPasswordFilePath = config.age.secrets.password.path;
      sshKeyPath = config.age.secrets.ssh-private-key.path;
      sshHostsPath = config.age.secrets.ssh-hosts.path;
      borgPassphrasePath = config.age.secrets.borg-passphrase.path;
      backupsKeyPath = config.age.secrets.backups-ssh-privkey.path;
    };
  };
}
