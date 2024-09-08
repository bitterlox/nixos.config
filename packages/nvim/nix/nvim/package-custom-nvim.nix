{ pkgs, name, addons }:
# configurations is "plugin" for some reason?????
let
  addon = import ../configurations/addons/addon.nix { inherit pkgs; };
  # there's an abstraction lurking here... when it works do it
  plugins = pkgs.lib.lists.flatten
    (builtins.filter (e: e != null) (builtins.map addon.getPlugins addons));
  tools = pkgs.lib.lists.flatten
    (builtins.filter (e: e != null) (builtins.map addon.getTools addons));
  luaFiles = builtins.map (pkg: "luafile ${pkg}") (pkgs.lib.lists.flatten
    (builtins.filter (e: e != [ ]) (builtins.map addon.getLuaCfgs addons)));
in pkgs.stdenv.mkDerivation { # add stuff to its paths
  name = "wrapped-nvim-${name}";
  # remove use of "with"
  src = with pkgs;
    wrapNeovim neovim-unwrapped {
      configure = {
        customRC = builtins.concatStringsSep "\n" luaFiles;
        packages = { all.start = plugins; };
      };
    };
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase = ''
    makeWrapper $src/bin/nvim \
    $out/bin/nvim \
    --prefix PATH ":" ${pkgs.lib.makeBinPath tools}
  '';
}
