username:
# this is a home-manager module
{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
{
  imports = [];
  config = {
    home.username = "${username}";
    home.homeDirectory = "/Users/${username}";
    home.stateVersion = "24.11";

    programs.ssh.enable = true;
    programs.ssh.includes = [ osConfig.lockbox.sshHostsPath ];

    # browserpass
    programs.browserpass.enable = true;
    programs.browserpass.browsers = [ "librewolf" ];
  };
}
