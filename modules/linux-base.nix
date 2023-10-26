{ config, pkgs, ... }: {
  time.timeZone = "Europe/Rome";

  # default packages
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user.name = "bitterlox";
      user.email = "bitterlox@pm.me";
    };
  };

  programs.ssh = {
    extraConfig = ''
      Host *
      IdentityFile ${config.age.secrets.ssh-private-key.path} 
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
