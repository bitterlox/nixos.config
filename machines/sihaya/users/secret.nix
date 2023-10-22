{ config, lib, ... }: {
  imports = [ ];
  config = {
    home-manager.users.angel = {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "*" = {
            serverAliveInterval = 120;
            identityFile =
              lib.debug.traceSeq config.age.secrets.angel-ssh-key.path
              config.age.secrets.angel-ssh-key.path;
          };
        };
      };
    };
  };

  options = { };
}
