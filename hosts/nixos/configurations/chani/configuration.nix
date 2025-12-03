{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/calibre
    ./modules/urbit
  ];
  config = {
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

    networking.hostName = "chani"; # Define your hostname.

    users = {
      mutableUsers = false;
      users.angel = {
        isNormalUser = true;
        hashedPasswordFile = config.lockbox.hashedPasswordFilePath;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        openssh.authorizedKeys.keys =
          let
            keys = config.lockbox.sshPubKeys;
          in
          [
            keys.voidbook
            keys.iphone
            keys.elewse
            keys.sietch
          ];
        # lingering is needed to keep systemd services running when nobody's logged in
        linger = true;
      };
    };

    # PROGRAMS #

    # maybe redundant ssh config
    # this is system level
    programs.ssh = {
      extraConfig = ''
        Host *
        IdentityFile ${config.lockbox.sshKeyPath} 
      '';
    };

    # SERVICES #
    customServices.calibre = {
      enable = true;
      virtualHost = "books.bittervoid.io";
    };

    customServices.urbit = {
      ${config.lockbox.urbit-moon1-patp} = {
        enable = true;
        virtualHost = "${config.lockbox.urbit-moon1-patp}.bittervoid.io";
        pierPath = "/home/angel/urbit/${config.lockbox.urbit-moon1-patp}";
        port = 8080;
      };
      ${config.lockbox.urbit-moon2-patp} = {
        enable = true;
        virtualHost = "${config.lockbox.urbit-moon2-patp}.bittervoid.io";
        pierPath = "/home/angel/urbit/${config.lockbox.urbit-moon2-patp}";
        port = 8081;
      };
      ${config.lockbox.urbit-moon3-patp} = {
        enable = true;
        virtualHost = "${config.lockbox.urbit-moon3-patp}.bittervoid.io";
        pierPath = "/home/angel/urbit/${config.lockbox.urbit-moon3-patp}";
        port = 8082;
      };
    };

    # HOME-MANAGER #

    # this is home-manager level
    home-manager.users.angel = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            serverAliveInterval = 120;
            identityFile = config.lockbox.sshKeyPath;
          };
          "github.com" = {
            identityFile = config.lockbox.sshKeyPath;
          };
        };
      };
    };

    nix.settings.secret-key-files = "/var/secrets/cache-priv-key.pem";
    nix.settings.trusted-users = [ "angel" ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
