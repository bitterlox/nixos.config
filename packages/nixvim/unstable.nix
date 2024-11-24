# ##############################################################################
#                                   TODO                                      #
###############################################################################
#                                                                             #
# + lua/globals                                                               #
# + lua/config/editor-config                                                  #
# + lua/config/plugins/plugin-config                                          #
# + lua/config/plugins/plugin-keybindings -- except neotest                   #
# + lua/config/plugins/plugin-config      -- except neotest, lsp-inlayhints   #
# ? lua/config/plugins/extra-config       -- except neotest                   #
#   + lua/config/plugins/extra-config/gopls                                   #
#   + lua/config/plugins/extra-config/ts_ls                                   #
#                                                                             #
###############################################################################

# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  imports =
    [ ./options.nix ./modules/editor-config ./modules/plugins-essentials.nix ];

  # we do this so we can add binaries to nvim's path, as some plugins require
  # external tool?

  package = let
    neovim = options.package.default;
    wrapNeovim = runtimeBinaries:
      pkgs.symlinkJoin {
        inherit (neovim) name meta lua;
        paths = [ neovim ];
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
        # this needs to be postBuild, i tried postInstall and it wasn't working
        postBuild = ''
          mv $out/bin/nvim $out/bin/nvim-nobins
          makeWrapper $out/bin/nvim-nobins \
            $out/bin/nvim \
            --prefix PATH ":" ${lib.makeBinPath config.runtimeBinaries}
        '';
      };
  in if (builtins.length config.runtimeBinaries) > 0 then
    wrapNeovim config.runtimeBinaries
  else
    neovim;
}
