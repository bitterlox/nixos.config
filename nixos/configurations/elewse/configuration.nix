myflakelib:
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware
    ./software
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  # enable lanzaboote for secureboot
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  # kernel 6.9.x has this error on log-on screen with bothers me
  # https://community.frame.work/t/usb-c-error-on-boot/52012
  # boot.kernelPackages = pkgs.linuxPackages_6_9;
  boot.kernelPackages = pkgs.linuxPackages_6_11;

  boot.loader.efi.canTouchEfiVariables = true;
  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.angel = {
    isNormalUser = true;
    description = "angel";
    hashedPasswordFile = config.lockbox.hashedPasswordFilePath;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    isSystemUser = true;
    hashedPasswordFile = "/persist/angelpasswd";
  };
  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=15
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # maybe redundant ssh config
  # this is system level
  programs.ssh = {
    extraConfig = ''
      Host *
      IdentityFile ${config.lockbox.sshKeyPath} 
    '';
  };

  services.borgbackup.jobs.elewse =
    let
      defaults = myflakelib.defaultBorgOptions {
        sshKeyPath = config.lockbox.backupsKeyPath;
        passphrasePath = config.lockbox.borgPassphrasePath;
      };
    in
    defaults
    // {
      repo = config.lockbox.borg-repo-url;
      paths = [ "/persist" ];
      user = "root";
      startAt = "weekly";
      # from; maybe implement backup fail notify as well
      # https://wiki.nixos.org/wiki/Borg_backup#Don't_try_backup_when_network_is_unreachable
      preHook = lib.mkBefore ''
        # waiting for internet after resume-from-suspend
        until ${lib.getExe pkgs.unixtools.ping} google.com -c1 -q >/dev/null; do :; done
      '';
    };

  # nix.settings = { };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
