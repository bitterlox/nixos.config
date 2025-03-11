secrets-flake: 
{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  user = "angel";
in
{
  config = {
    age.identityPaths = [ "/Users/angel/.ssh/voidbook_ed25519" ];
    age.secrets = {
      # ssh-private-key = {
      #   file = secrets-flake.elewse.ssh.private-key;
      #   mode = "600";
      #   owner = "angel";
      #   group = "users";
      # };
      # password = {
      #   file = secrets-flake.elewse.password;
      #   mode = "600";
      #   owner = "angel";
      #   group = "users";
      # };
      ssh-hosts = {
        file = secrets-flake.common.ssh-hosts;
        symlink = true;
        path = "/Users/angel/.ssh/ssh-host";
        mode = "644";
        owner = "${user}";
        group = "staff";
      };
      # borg-passphrase = {
      #   file = secrets-flake.elewse.borg-passphrase;
      #   mode = "600";
      #   owner = "angel";
      #   group = "users";
      # };
      # backups-ssh-privkey = {
      #   file = secrets-flake.elewse.backups-ssh-privkey;
      #   mode = "600";
      #   owner = "angel";
      #   group = "users";
      # };
    };
    lockbox = {
      sshHostsPath = config.age.secrets.ssh-hosts.path;
      # borgPassphrasePath = config.age.secrets.borg-passphrase.path;
      # backupsKeyPath = config.age.secrets.backups-ssh-privkey.path;
      # inherit (secrets-flake.elewse) borg-repo-url;
    };
  };
}
