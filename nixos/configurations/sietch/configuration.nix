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
        hashedPasswordFile =
          config.age.secrets.password.path; # move to private module maybe
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        openssh.authorizedKeys.keys = [ config.sshPubKeys.voidbook ];
      };
    };

    soft-serve.adminPublicKeys = {
      inherit (config.sshPubKeys) voidbook chani iphone;
    };

    # https://nixos.wiki/wiki/Borg_backup
    # see: Don't try backup when unit is unavailable

    services.borgbackup.jobs.sietch = let
      secrets = config.age.secrets;
      defaults = myflakelib.defaultBorgOptions {
        passphrasePath = secrets.borg-passphrase.path;
        sshKeyPath = secrets.ssh-private-key.path;
      };
    in defaults // {
      repo = "ssh://j6zbx5gr@j6zbx5gr.repo.borgbase.com/./repo";
      paths = [ "/var/lib/soft-serve" ];
      user = "root";
      startAt = "*-*-* 02/2:00:00";
      persistentTimer = true;
      preHook = ''
        systemctl stop soft-serve.service
      '';
      postHook = ''
        systemctl start soft-serve.service
      '';
    };
  };
}
