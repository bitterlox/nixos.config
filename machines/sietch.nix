{ config, ssh-public-keys, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./sietch-hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "sietch"; # Define your hostname.

  users = {
    mutableUsers = false;
    users.angel = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.password.path;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [ ssh-public-keys.voidbook ];
    };
  };
}