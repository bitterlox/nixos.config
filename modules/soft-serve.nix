{ pkgs, ssh-public-keys, ... }:
let
  softServeDataPath = "/var/lib/soft-serve";
  softServeAdminKeys = pkgs.writeText "soft-serve-admin-keys"
    (pkgs.lib.strings.concatStringsSep "\n"
      (builtins.attrValues ssh-public-keys));
  soft-serve = pkgs.stdenv.mkDerivation {
    name = "soft-serve";
    src = pkgs.soft-serve;
    inherit softServeDataPath;
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    adminKeys = softServeAdminKeys;
    #    if [[ ! -d $softServeDataPath ]]; then
    #      mkdir $softServeDataPath
    #        fi
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper $src/bin/soft \
        $out/bin/soft \
        --set SOFT_SERVE_DATA_PATH $softServeDataPath \
        --set SOFT_SERVE_INITIAL_ADMIN_KEYS $adminKeys
    '';
  };
in {
  imports = [ ];
  config = {
    environment.systemPackages = [ soft-serve ];
    systemd.services.soft-serve = {
      unitConfig = {
        # if it blows up i'll blame the icecream emoji
        Description = "Soft Serve git server 🍦";
        Documentation = "https://github.com/charmbracelet/soft-serve";
        Requires = "network-online.target";
        After = "network-online.target";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
        ExecStart = "${soft-serve}/bin/soft serve";
        #WorkingDirectory = "/var/local/lib/soft-serve";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  options = { };
}
