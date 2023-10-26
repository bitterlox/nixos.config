{ pkgs }: {
  build-machine-secrets = secrets-flake: machine:
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
          password = {
            file = secrets-flake.sietch.password;
            mode = "600";
            owner = "angel";
            group = "users";
          };
        };
      };
    in (builtins.getAttr machine secrets);
}
