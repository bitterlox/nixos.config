hyprlandPackage:
{ config, pkgs, lib, ... }: {
  # wayland stuff
  security.polkit.enable = true;
  hardware.opengl.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.package = hyprlandPackage;
  services.pipewire = {
    # needed for hyprland
    #systemWide = true;
    wireplumber.enable = true;
  };
}
