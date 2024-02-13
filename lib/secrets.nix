{ secrets-flake, machine-name }:
let
  secrets = {
    chani = {
      ssh-private-key = {
        file = secrets-flake.chani.ssh.private-key;
        mode = "600";
        owner = "angel";
        group = "users";
      };
      password = {
        file = secrets-flake.chani.password;
        mode = "600";
        owner = "angel";
        group = "users";
      };
    };
    sietch = {
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
      soft-serve-ssh-public-url = secrets-flake.sietch.soft-serve-ssh-public-url;
    };
  };
in (builtins.getAttr machine-name secrets)
