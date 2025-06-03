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
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  specialArgs,
  ...
}:
{
  imports = [
    ./options.nix
    ./modules/editor-config
    ./modules/plugins/_essentials.nix
    ./modules/plugins/_extras.nix
    ./modules/plugins/lsp.nix
    ./modules/plugins/languages/_all.nix
  ];
}
