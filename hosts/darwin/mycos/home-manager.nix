# this hs a nix-darwin module
username: inputs: homeModules: darwinModules:
{ lib, ... }:
{
  config = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
    home-manager.users.angel =
      # this is a home-manager module
      {
        pkgs,
        lib,
        osConfig,
        config,
        ...
      }:
      {
        imports =
          let
            m = homeModules;
          in
          [
            inputs.mac-app-util.homeManagerModules.default
            m.fzf
            m.tmux
            m.bash
          ];
        options = {
        };
        config = {

          home.username = "${username}";
          home.homeDirectory = "/Users/${username}";
          home.stateVersion = "24.11";

          programs.ssh.enable = true;
          programs.ssh.includes = [ osConfig.lockbox.sshHostsPath ];

          # browserpass
          programs.browserpass.enable = true;
          programs.browserpass.browsers = [ "firefox" ];
        };
      };
  };
}
