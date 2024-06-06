{ config, pkgs, lib, ... }: {
  imports = [ ./sound.nix ./compositor.nix ./greeter.nix ];

  environment.systemPackages = lib.mkBefore (with pkgs; [
    #neovim-light # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default
    neovim-full
    fprintd
    git
    brightnessctl
    #  wget
  ]);

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
  services.openssh = lib.mkForce {
    enable = false;
    openFirewall = false;
    # if we just set ports to [] it still listens on 22 since if we omit "Port" from sshd_config
    # ssh still listens on default port (see sshd_config man)
    # if however we *also* enable startWhenNeeded the sshd service is started on-demand by a
    # systemd socket, but since the port on that is set based on services.openssh.ports and it is
    # empty we have a systemd socket listening on no ports, which i think effectively disables ssh
    ports = [ ];
    startWhenNeeded = true;
  };
}
