{ shellcheck, nodePackages, stdenv, makeBinaryWrapper }:
let bashls = nodePackages.bash-language-server;
in stdenv.mkDerivation {
  inherit (bashls) name version;
  dontUnpack = true;
  src = bashls;
  buildInputs = [ shellcheck ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  # could user lib.makeBinPath
  installPhase = ''
    makeWrapper $src/bin/bash-language-server \
      $out/bin/bash-language-server \
      --prefix PATH ":" "${shellcheck}/bin"
  '';
}
