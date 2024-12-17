# this is a nixvim module
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  specialArgs,
}:
{
  colorschemes.palette.enable = true;
  colorschemes.palette.settings = {
      palettes = {
          main = "dark";
          accent = "dark";
          state = "dark";
        };
      custom_palettes = {
          main = {
            shadesOfBlue = {
              color0 = "#121527";
              color1 = "#1A1E39";
              color2 = "#232A4D";
              color3 = "#3E4D89";
              color4 = "#687BBA";
              color5 = "#A4B1D6";
              color6 = "#bdbfc9";
              color7 = "#DFE5F1";
              color8 = "#e9e9ed";
              };
            };
            accent = {
              shadesOfBlue = {
                accent0 = "#121527"; # red
                accent1 = "#1A1E39"; # orange
                accent2 = "#232A4D"; # yellow
                accent3 = "#3E4D89"; # green
                accent4 = "#687BBA"; # blue
                accent5 = "#A4B1D6"; # pink
                accent6 = "#bdbfc9"; # purple
                };
              };

            state = {
              shadesOfBlue = {
                error = "#121527";
                hint = "#1A1E39";
                info = "#232A4D";
                ok = "#3E4D89";
                warning = "#bdbfc9";
                };
              };
        };
    };
}
