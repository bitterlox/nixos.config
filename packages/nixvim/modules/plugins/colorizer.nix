# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  plugins.colorizer.enable = true;
  plugins.colorizer.settings.buftypes = [ "*" ];
  plugins.colorizer.settings.filetypes = [ "*" ];

  plugins.colorizer.user_default_options = {
    # "name" codes like blue or blue
    names = true;
    # #rgb hex codes
    rgb = true;
    # #rrggbb hex codes
    rrggbb = true;
    # #rrggbbaa hex codes
    rrggbbaa = false;
    # 0xaarrggbb hex codes
    aarrggbb = false;
    # css rgb() and rgba() functions
    rgb_fn = false;
    # css hsl() and hsla() functions
    hsl_fn = false;
    # enable all css features: rgb_fn; hsl_fn, names, rgb, rrggbb
    css = true;
    # enable all css *functions*: rgb_fn; hsl_fn
    css_fn = true;

    # set the display mode
    # highlighting mode.  'background'|'foreground'|'virtualtext'
    mode = "virtualtext";
    # tailwind colors.
    # boolean|'normal'|'lsp'|'both'.  true is same as normal
    # enable tailwind colors
    tailwind = false;

    # parsers can contain values used in |user_default_options|
    # enable sass colors
    sass = {
      enable = false;
      parsers = [ "css" ];
    };

    # virtualtext character to use
    virtualtext = "■";

    # display virtualtext inline with color
    virtualtext_inline = false;

    # virtualtext highlight mode: 'background'|'foreground'
    virtualtext_mode = "foreground";

    # update color values even if buffer is not focused
    # example use: cmp_menu; cmp_docs
    always_update = false;
  };

}
