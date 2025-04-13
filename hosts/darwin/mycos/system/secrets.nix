secrets-flake: agenixModule:
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
  imports = [
    agenixModule
  ];
  options = {
    lockbox = lib.mkOption {
      type = with lib.types; attrsOf (either str (attrsOf str));
      default = { };
      example = {
        mysecret = "superSecretPassword";
      };
      description = lib.mdDoc "An attrset of secrets and less secret values";
    };
  };
  config = {
    age.identityPaths = [ "/Users/angel/.ssh/mykos_agenix_ed25519" ];
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
        file = lib.debug.traceVal  "${secrets-flake}/common/ssh-hosts.age";
        # symlink = true;
        # path = "/Users/angel/.ssh/ssh-host";
        mode = "600";
        owner = "${user}";
        group = "wheel";
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
