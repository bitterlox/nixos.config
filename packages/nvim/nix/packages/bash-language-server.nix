{ pkgs }:
let
  bashls = pkgs.nodePackages.bash-language-server;
  shellcheck = pkgs.shellcheck;
in pkgs.stdenv.mkDerivation {
  inherit (bashls) name version;
  dontUnpack = true;
  src = bashls;
  buildInputs = [ shellcheck ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  installPhase = ''
    makeWrapper $src/bin/bash-language-server \
      $out/bin/bash-language-server \
      --prefix PATH ":" "${shellcheck}/bin"
  '';
}
