{ config, lib, ... }: {
  imports = [ ];
  config = {
    home-manager.users.angel = {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "*" = {
            serverAliveInterval = 120;
            identityFile = config.age.secrets.ssh-private-key.path;
          };
        };
      };
    };
  };
  options = {};
}
