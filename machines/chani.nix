{ config, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./chani-hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "chani"; # Define your hostname.

  users = {
    mutableUsers = false;
    users.angel = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.password.path;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/JDXLqz8IKnkWZollqDXs93vOgOcnbTSUcPCP0jhug" # voidbook
      ];
    };
  };

  programs.ssh = {
    extraConfig = ''
      Host *
      IdentityFile ${config.age.secrets.ssh-private-key.path} 
    '';
  };
}
