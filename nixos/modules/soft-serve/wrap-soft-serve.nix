{ pkgs, adminKey, dataPath, ports, sshPublicUrlFilePath }:
pkgs.stdenv.mkDerivation {
  name = "wrapped-soft-serve";
  src = pkgs.soft-serve;
  bash = pkgs.bash;
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  inherit adminKey;
  inherit dataPath;
  inherit (ports) ssh http git;
  inherit sshPublicUrlFilePath;
  installPhase = ''
    sshPublicUrl="$(cat $sshPublicUrlFilePath)"
    mkdir -p $out/bin
    makeWrapper $src/bin/soft \
      $out/bin/soft \
      --prefix PATH ":" "$bash/bin" \
      --set SOFT_SERVE_DATA_PATH $dataPath \
      --set SOFT_SERVE_INITIAL_ADMIN_KEYS $adminKey \
      --set SOFT_SERVE_SSH_PUBLIC_URL $sshPublicUrl \
      --set SOFT_SERVE_SSH_LISTEN_ADDR :$ssh \
      --set SOFT_SERVE_HTTP_LISTEN_ADDR :$http \
      --set SOFT_SERVE_GIT_LISTEN_ADDR :$git \
  '';
  #  --set SOFT_SERVE_DEBUG 1 \
  #  --set SOFT_SERVE_VERBOSE 1 \
}
