{ config, pkgs, lib, ... }: {
  time.timeZone = "Europe/Rome";

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  # default packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    psmisc # killall + other utils
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

  programs.mosh = {
    enable = true;
    #    openFirewall = true;
  };

  # use en_GB locale so any app that grabs that knows i want dates in
  # dd/MM/y
  # keepin en_US since it's default it might save some app from braking
  # someday
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "it_IT.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

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
