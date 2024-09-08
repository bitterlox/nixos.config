hyprlandPackage:
{ config, pkgs, lib, ... }: {
  imports =
    [ ./hardware.nix (import ./compositor.nix hyprlandPackage) ./greeter.nix ];

  # we have mkBefore here due to the interactions between this declaration
  # of environment.systemPackages and the one in linux-base NixOSmodule
  environment.systemPackages = lib.mkBefore (with pkgs; [
    git
    brightnessctl
    libreoffice-qt6-fresh
    joplin-desktop
    #  wget
  ]);

  ## programs ##

  # file manager - thunar

  # https://nixos.wiki/wiki/Thunar
  programs.thunar.enable = true;
  programs.thunar.plugins = [ pkgs.xfce.thunar-volman ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  #

  ## services ##

  services.fprintd.enable = true;
  services.fwupd.enable = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # we just have this enabled to create an ssh host key so i can use it to encrypt secrets
  # we try to configure it to be as unusable as possible
  services.openssh = lib.mkForce {
    #enable = true;
    enable = false;
    # setting openFirewall to false while enable is true will still have ssh
    # listening locally on port 22 even though you couldn't connect to it from
    # the outside
    openFirewall = false;
    # if we just set ports to [] it still listens on 22 since if we omit "Port"
    # from sshd_config ssh still listens on default port (see sshd_config man)
    # if however we *also* enable startWhenNeeded the sshd service is started
    # on-demand by a systemd socket, but since the port on the socket is set
    # based on services.openssh.ports and it is empty we have a systemd socket
    # listening on no ports, which i think effectively disables ssh
    ports = [ ];
    startWhenNeeded = true;
  };
}
