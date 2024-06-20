myflakelib:
{ config, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  config = {
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

    networking.hostName = "sietch"; # Define your hostname.

    users = {
      mutableUsers = false;
      users.angel = {
        isNormalUser = true;
        hashedPasswordFile = config.lockbox.hashedPasswordFilePath;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        openssh.authorizedKeys.keys = [ config.sshPubKeys.voidbook ];
      };
    };

    programs.ssh = {
      extraConfig = ''
        Host *
        IdentityFile ${config.lockbox.sshKeyPath} 
      '';
    };

    soft-serve = {
      adminPublicKeys = {
        inherit (config.sshPubKeys) voidbook chani iphone elewse;
      };
      sshPublicUrl = config.lockbox.softServeSshPublicUrl;
    };

    # https://nixos.wiki/wiki/Borg_backup
    # see: Don't try backup when unit is unavailable
    services.borgbackup.jobs.sietch = let
      defaults = myflakelib.defaultBorgOptions {
        inherit (config.lockbox) sshKeyPath;
        passphrasePath = config.lockbox.borgPassphrasePath;
      };
    in defaults // {
      repo = "ssh://j6zbx5gr@j6zbx5gr.repo.borgbase.com/./repo";
      paths = [ "/var/lib/soft-serve" ];
      user = "root";
      startAt = "*-*-* 02/2:00:00";
      # when we stop this it might be nice to have a temp
      # ssh server spun up that says backup in progress
      preHook = ''
        systemctl stop soft-serve.service
      '';
      postHook = ''
        systemctl start soft-serve.service
      '';
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
