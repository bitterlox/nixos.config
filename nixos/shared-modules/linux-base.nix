{ config, pkgs, ... }: {
  time.timeZone = "Europe/Rome";

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  # default packages
  environment.systemPackages = with pkgs; [ neovim-light wget git ];

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

  programs.mosh = {
    enable = true;
#    openFirewall = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings = {
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };
}
