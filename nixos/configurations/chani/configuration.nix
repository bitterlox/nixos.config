{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  config = {
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

    networking.hostName = "chani"; # Define your hostname.

    environment.systemPackages = [ pkgs.neovim-full ];

    users = {
      mutableUsers = false;
      users.angel = {
        isNormalUser = true;
        hashedPasswordFile = config.lockbox.hashedPasswordFilePath;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        openssh.authorizedKeys.keys = let keys = config.sshPubKeys;
        in [ keys.voidbook keys.iphone ];
      };
    };

    # maybe redundant ssh config
    # this is system level
    programs.ssh = {
      extraConfig = ''
        Host *
        IdentityFile ${config.lockbox.sshKeyPath} 
      '';
    };

    # this is home-manager level
    home-manager.users.angel = {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "*" = {
            serverAliveInterval = 120;
            identityFile = config.lockbox.sshKeyPath;
          };
          "github.com" = { identityFile = config.lockbox.sshKeyPath; };
        };
      };
    };

  };
}
