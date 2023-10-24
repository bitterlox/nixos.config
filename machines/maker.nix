{ config, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./maker-hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "maker"; # Define your hostname.

  users = {
    mutableUsers = false;
    users.angel = {
      isNormalUser = true;
      hashedPassword =
        "$y$j9T$MhFzL4qfLPfhkcF/akhD70$fUWTOTgHhF3lz7pAgn9jLiUFLhcukoWfFu4hmAZwa45";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/JDXLqz8IKnkWZollqDXs93vOgOcnbTSUcPCP0jhug"
      ];
    };
  };
}
