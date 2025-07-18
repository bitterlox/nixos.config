myflakelib:
{ config, lib, ... }: {
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
      # NEVER TURN THIS OFF PLS
      enable = true; # NEVER TURN THIS OFF PLS
      # NEVER TURN THIS OFF PLS ^^^^
      adminPublicKeys = {
        inherit (config.lockbox.sshPubKeys) voidbook chani iphone elewse;
      };
      sshPublicUrl = config.lockbox.softServeSshPublicUrl;
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
    };

    nix.distributedBuilds = true;
    nix.buildMachines = [{
      system = "x86_64-linux";
      sshKey = config.lockbox.sshKeyPath;
      hostName = "chani";
      sshUser = "angel";
      protocol = "ssh-ng";
    }];
    nix.settings.trusted-substituters = [ "ssh-ng://chani" ];
    nix.settings.trusted-public-keys = [
      "chani-1:L30eiZk3KcfCWTmQGbG29d/5rB/AuwZS6KTMm5up1vc=" # this one is cache-pub-key.pem content
    ];
    nix.settings.trusted-users = [ "root" ];
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
