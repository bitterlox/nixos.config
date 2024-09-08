# a lot of formatters / linters should be bundled with the
# respective lsps (nixfmt, shellcheck, etc)
{ pkgs, addon }: {
  gopls = addon.makeToolAddon {
    pkg = pkgs.gopls;
    config = [ ../../../../../lua/config/plugins/extra-config/bashls.lua ];
  };
  lua-language-server = addon.makeToolAddon {
    pkg = pkgs.lua-language-server;
    config =
      [ ../../../../../lua/config/plugins/extra-config/rust_analyzer.lua ];
  };
  rust-analyzer = addon.makeToolAddon { pkg = pkgs.rust-analyzer; };
  efm-langserver = addon.makeToolAddon {
    pkg = pkgs.efm-langserver;
    config =
      [ ../../../../../lua/config/plugins/extra-config/efm_langserver.lua ];
  };
  nil = addon.makeToolAddon {
    pkg = pkgs.nil;
    config = [ ../../../../../lua/config/plugins/extra-config/nil.lua ];
  };

  # nodePackages
  bash-language-server = addon.makeToolAddon {
    pkg = pkgs.nodePackages.bash-language-server;
    config = [ ../../../../../lua/config/plugins/extra-config/bashls.lua ];
  };
  typescript-language-server = addon.makeToolAddon {
    pkg = pkgs.nodePackages.typescript-language-server;
    config = [ ../../../../../lua/config/plugins/extra-config/tsserver.lua ];
  };
}
