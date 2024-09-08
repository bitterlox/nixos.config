{ lib, ... }: {
  imports = [ ./options.nix ];
  perSystem = { pkgs, ... }:
    let
      # if we pass flake-part's top-level arg `lib` this doesn't work wtf???
      addon = import ./addons/addon.nix { inherit pkgs; }; # <---
      tools = import ./addons/tools { inherit pkgs addon; };
      plugins = import ./addons/plugins { inherit pkgs addon; };
      config = import ./addons/config { inherit pkgs addon; };
      base = [
        config.editor-config
        config.globals
        plugins.completion
        plugins.essentials

        # required by tree-sitter
        tools.ripgrep
        tools.fd
      ];
    in {
      config.neovim.editors = [
        {
          name = "full";
          addons = base ++ [
            # lsps
            tools.lsps.gopls
            tools.lsps.lua-language-server
            tools.lsps.rust-analyzer
            tools.lsps.nil
            tools.lsps.bash-language-server
            tools.lsps.typescript-language-server
            tools.lsps.efm-langserver

            # linters
            tools.yamllint
            tools.jsonlint
            tools.markdownlint-cli

            # formatters
            tools.shellharden
            tools.stylua
            tools.nixfmt
          ];
        }
        {
          name = "light";
          addons = base ++ [
            # lsps
            tools.lsps.lua-language-server
            tools.lsps.nil
            tools.lsps.bash-language-server

            # linters
            tools.markdownlint-cli

            # formatters
            tools.shellharden
            tools.stylua
            tools.nixfmt
          ];
        }
      ];
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
