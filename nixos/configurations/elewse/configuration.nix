# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  # enable lanzaboote for secureboot
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elewse"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # wayland stuff
  security.polkit.enable = true;
  hardware.opengl.enable = true;
  programs.hyprland.enable = true;
  services.pipewire = {
    # needed for hyprland
    #systemWide = true;
    wireplumber.enable = true;
  };
  services.greetd = let
    tuigreetTheme =
      "border=lightmagenta;text=lightblue;prompt=lightblue;time=lightmagenta;action=yellow;button=orange;container=lightblue;input=orange";
    hypr-run = pkgs.writeShellScriptBin "hypr-run" ''
      export XDG_SESSION_TYPE="wayland"
      export XDG_SESSION_DESKTOP="Hyprland"
      export XDG_CURRENT_DESKTOP="Hyprland"

      systemd-run --user --scope --collect --quiet --unit="hyprland" \
          systemd-cat --identifier="hyprland" ${pkgs.hyprland}/bin/Hyprland $@

      ${pkgs.hyprland}/bin/hyperctl dispatch exit
    '';
  in {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd ${lib.getExe hypr-run}'';
      # theme support added in 0.9.0
      # --theme ${tuigreetTheme} \
    };
  };
  environment.etc."greetd/environments".text = ''
    sway
    Hyprland
  '';

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.angel = {
    isNormalUser = true;
    description = "angel";
    hashedPasswordFile = config.lockbox.hashedPasswordFilePath;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
      pkgs.neovim-light
      #  thunderbird
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    isSystemUser = true;
    hashedPasswordFile = "/persist/angelpasswd";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  # setting this in the nixpkgs instance in default.nix
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim-light # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default
    neovim-full
    fprintd
    git
    #  wget
  ];

  services.fprintd.enable = true;
  services.fwupd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # we just have this enabled to create an ssh host key so i can use it to encrypt secrets
  # we try to configure it to be as unusable as possible
  # TODO: override linux-base definition:
  services.openssh = {
    enable = lib.mkForce false;
    openFirewall = false;
    # if we just set ports to [] it still listens on 22 since if we omit "Port" from sshd_config
    # ssh still listens on default port (see sshd_config man)
    # if however we *also* enable startWhenNeeded the sshd service is started on-demand by a
    # systemd socket, but since the port on that is set based on services.openssh.ports and it is
    # empty we have a systemd socket listening on no ports, which i think effectively disables ssh
    ports = [ ];
    startWhenNeeded = true;
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
