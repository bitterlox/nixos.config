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
        openssh.authorizedKeys.keys = let keys = config.lockbox.sshPubKeys;
        in [ keys.voidbook keys.elewse keys.chani ];
      };
    };

    programs.ssh = {
      extraConfig = ''
        Host *
        IdentityFile ${config.lockbox.sshKeyPath} 
      '';
    };

    soft-serve = {
      enable = true;
      adminPublicKeys = {
        inherit (config.lockbox.sshPubKeys) voidbook chani iphone elewse;
      };
      sshPublicUrl = config.lockbox.softServeSshPublicUrl;
    };

    firefly-iii = {
      enable = true;
      virtualHosts = {
        firefly-iii = "ff.bittervoid.io";
        data-importer = "di.bittervoid.io";
      };
    };

    # https://nixos.wiki/wiki/Borg_backup
    # see: Don't try backup when unit is unavailable
    services.borgbackup.jobs = let
      defaults = myflakelib.defaultBorgOptions {
        inherit (config.lockbox) sshKeyPath;
        passphrasePath = config.lockbox.borgPassphrasePath;
      } // {
        user = "root";
      };
    in {
      soft-serve = defaults // {
        repo = config.lockbox.borg-repo-urls.soft-serve;
        paths = [ "/var/lib/soft-serve" ];
        startAt = "*-*-* 02/2:00:00";
        # when we stop this it might be nice to have a temp
        # ssh server spun up that says backup in progress
        preHook = "systemctl stop soft-serve.service";
        postHook = "systemctl start soft-serve.service";
      };
      firefly-iii = defaults // {
        repo = config.lockbox.borg-repo-urls.firefly-iii;
        paths = [ "/var/backup/mysql/" "/var/lib/firefly-iii/storage/upload/" ];
        startAt = "Mon *-*-* 01:00:00";
        # don't need hooks since we're backing up an inert sql dump
      };
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
