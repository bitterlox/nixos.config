# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  # enable graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # set drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  # services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = [
    pkgs.lact # linux amdgpu Controller - for overclocking and such
    pkgs.amdgpu_top # top but for amd gpus
    pkgs.protonup-qt # manage proton versions
  ];

  # extra config needed by the lact daemon
  # see this: https://wiki.nixos.org/wiki/AMD_GPU
  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
