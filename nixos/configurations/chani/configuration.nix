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
        hashedPasswordFile =
          config.age.secrets.password.path; # move to private module maybe
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        openssh.authorizedKeys.keys = let keys = config.sshPubKeys;
        in [ keys.voidbook keys.iphone ];
      };
    };
  };
}
