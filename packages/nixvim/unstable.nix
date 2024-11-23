###############################################################################
#                                   TODO                                      #
###############################################################################
#                                                                             #
# + lua/globals                                                               #
# + lua/config/editor-config                                                  #
# + lua/config/plugins/plugin-config                                          #
# + lua/config/plugins/plugin-keybindings -- except neotest                   #
# + lua/config/plugins/plugin-config      -- except neotest, lsp-inlayhints   #
# - lua/config/plugins/extra-config       -- except neotest                   #
#                                                                             #
###############################################################################


# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {
  imports =
    [ ./options.nix ./modules/editor-config ./modules/plugins-essentials.nix ];

  # we do this so we can add binaries to nvim's path, as some plugins require
  # external tools

  package = let neovim = options.package.default;
  in pkgs.symlinkJoin {
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
}
