# ##############################################################################
#                                   TODO                                      #
###############################################################################
#                                                                             #
# + lua/globals                                                               #
# + lua/config/editor-config                                                  #
# + lua/config/plugins/plugin-config                                          #
# + lua/config/plugins/plugin-keybindings                                     #
# + lua/config/plugins/plugin-config      -- lsp-inlayhints                   #
# - lua/config/plugins/extra-config                                           #
#   + lua/config/plugins/extra-config/gopls                                   #
#   + lua/config/plugins/extra-config/ts_ls                                   #
#   + lua/config/plugins/extra-config/bash_ls                                 #
#   + lua/config/plugins/extra-config/lua_ls                                  #
#   x lua/config/plugins/extra-config/nil_ls                                  #
#   + lua/config/plugins/extra-config/rust_analyzer                           #
#   + lua/config/plugins/extra-config/efm-langserver                          #
#                                                                             #
#                                                                             #
# after port:                                                                 #
# + switch nvim lsp to nixd                                                   #
#                                                                             #
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
