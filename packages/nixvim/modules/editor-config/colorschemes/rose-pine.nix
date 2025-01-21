# this is a nixvim module
args@{ ... }:
{
  colorschemes.rose-pine.enable = true;

  colorschemes.rose-pine.settings = {
    variant = "main";
    dark_variant = "main";
    dim_inactive_windows = true;
    extend_background_behind_borders = true;

    styles = {
      bold = true;
      italic = true;
      transparency = false;
    };

    enable = {
      terminal = true;
      legacy_highlights = true; # Improve compatibility for previous versions of Neovim
      migrations = true; # Handle deprecated options automatically
    };

    # groups = {
    #   border = "muted";
    #   link = "iris";
    #   panel = "surface";

    #   error = "love";
    #   hint = "iris";
    #   info = "foam";
    #   note = "pine";
    #   todo = "rose";
    #   warn = "gold";

    #   git_add = "foam";
    #   git_change = "rose";
    #   git_delete = "love";
    #   git_dirty = "rose";
    #   git_ignore = "muted";
    #   git_merge = "iris";
    #   git_rename = "pine";
    #   git_stage = "iris";
    #   git_text = "rose";
    #   git_untracked = "subtle";

    #   h1 = "iris";
    #   h2 = "foam";
    #   h3 = "rose";
    #   h4 = "gold";
    #   h5 = "pine";
    #   h6 = "foam";
    # };

    # https://rosepinetheme.com/palette/ingredients/
    # highlight_groups = {
    #   border = "muted";
    #   link = "iris";
    #   panel = "surface";

    #   error = "love";
    #   hint = "iris";
    #   info = "foam";
    #   note = "pine";
    #   todo = "rose";
    #   warn = "gold";

    #   git_add = "foam";
    #   git_change = "rose";
    #   git_delete = "love";
    #   git_dirty = "rose";
    #   git_ignore = "muted";
    #   git_merge = "iris";
    #   git_rename = "pine";
    #   git_stage = "iris";
    #   git_text = "rose";
    #   git_untracked = "subtle";

    #   h1 = "iris";
    #   h2 = "foam";
    #   h3 = "rose";
    #   h4 = "gold";
    #   h5 = "pine";
    #   h6 = "foam";
    # };
  };
}
