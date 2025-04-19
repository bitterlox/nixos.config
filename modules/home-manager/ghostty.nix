# this is a home-manager module
# adapted from:
# https://github.com/nix-community/home-manager/blob/release-24.11/modules/programs/ghostty.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  keyValueSettings = {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
  keyValue = pkgs.formats.keyValue keyValueSettings;
  settings = {
    # list themes with ghostty +list-themes
    # tried: srcery
    theme = "srcery";
    background-opacity = 0.8;
    background-blur-radius = 20;
  };
  themes = { };
in
{
  config = {
    # MacOS also supports XDG configuration directory, so we use it for both
    # Linux and macOS to reduce complexity
    xdg.configFile = lib.mkMerge [
      {
        "ghostty/config" = lib.mkIf (settings != { }) {
          source = keyValue.generate "ghostty-config" settings;
          # onChange = "${lib.getExe cfg.package} +validate-config";
        };
      }

      (lib.mkIf (themes != { }) (
        lib.mapAttrs' (name: value: {
          name = "ghostty/themes/${name}";
          value.source = keyValue.generate "ghostty-${name}-theme" value;
        }) themes
      ))
    ];

    programs.bash.initExtra = lib.mkMerge [
      # enable bash integration
      (lib.mkOrder 101 ''
        if [[ -n "''${GHOSTTY_RESOURCES_DIR}" ]]; then
          builtin source "''${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
        fi
      '')
      # fix error: `missing or unsuitable terminal: xterm-ghostty`
      ''
        if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
          export TERM=xterm-256color
        fi
      ''
    ];
  };
}
