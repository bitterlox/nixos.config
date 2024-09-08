{ pkgs, addon }:
let
  customThemes = builtins.attrValues pkgs.vimPlugins.customThemes;
in addon.makePluginAddon {
  pkg = [ pkgs.vimPlugins.rose-pine ] ++ customThemes;
  config = [ ../../../../../lua/config/plugins/extra-config/themes.lua ];
}
