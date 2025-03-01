{ config, pkgs, lib, ... }: {

  # network #
  networking.hostName = "elewse"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # bluetooth #
  hardware.bluetooth = {
    enable = true;
    # thought i needed this for magic mouse but no
    #input = { General.UserspaceHID = true; };
  };
  #environment.systemPackages = [ pkgs.overskride ];
  environment.systemPackages = [ pkgs.blueman ];

  # sound #
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
}
