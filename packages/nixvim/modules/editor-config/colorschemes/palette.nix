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
          main = "shadesOfBlue";
          accent = "dark";
          state = "dark";
        };
      custom_palettes = {
          main = {
            shadesOfBlue = {
              color0 = "#121527";
color1 = "#242847";
color2 = "#343e73";
color3 = "#3E4D89";
color4 = "#2f3854";
color5 = "#5a6aa1";
color6 = "#A4B1D6";
              color7 = "#95a9cc";
              color8 = "#d1d5ed";
              };
            };
            accent = {
              shadesOfBlue = {
                accent0 = "#1A1E39"; # red
                accent1 = "#3e457a"; # orange
                accent2 = "#232A4D"; # yellow
                accent3 = "#3E4D89"; # green
                accent4 = "#687BBA"; # blue
                accent5 = "#A4B1D6"; # pink
                accent6 = "#bdbfc9"; # purple
                };
              };

            state = {
              shadesOfBlue = {
                error = "#1A1E39";
                hint = "#3e457a";
                info = "#232A4D";
                ok = "#3E4D89";
                warning = "#bdbfc9";
                };
              };
        };
    };
}
