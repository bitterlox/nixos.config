{ config, pkgs, lib, ... }: {
  # wayland stuff
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  programs.hyprland.enable = true;
  services.pipewire = {
    # needed for hyprland
    #systemWide = true;
    wireplumber.enable = true;
  };
}
