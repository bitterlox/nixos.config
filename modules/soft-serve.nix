{ pkgs, config, ssh-public-keys, ... }:
let
  softServeDataPath = "/var/lib/soft-serve";
  softServeAdminKeys = pkgs.writeText "soft-serve-admin-keys"
    (pkgs.lib.strings.concatStringsSep "\n"
      [ (builtins.getAttr "sietch" ssh-public-keys) ]);
  voidBookPublicKey = (builtins.getAttr "voidbook" ssh-public-keys);
  #    softServeAdminKeys = pkgs.lib.debug.traceSeqN 1 "${softServeAdminKeys'}" softServeAdminKeys';
  soft-serve = pkgs.stdenv.mkDerivation {
    name = "soft-serve";
    src = pkgs.soft-serve;
    inherit softServeDataPath;
    bash = pkgs.bash;
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    adminKeys = softServeAdminKeys;
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper $src/bin/soft \
        $out/bin/soft \
        --prefix PATH ":" "$bash/bin" \
        --set SOFT_SERVE_DATA_PATH $softServeDataPath \
        --set SOFT_SERVE_INITIAL_ADMIN_KEYS $adminKeys \
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
      postStart = ''
        sleep 1
        ${pkgs.openssh}/bin/ssh -i ${config.age.secrets.ssh-private-key.path} -o "StrictHostKeyChecking=no" -p 23231 localhost settings allow-keyless false
        ${pkgs.openssh}/bin/ssh -i ${config.age.secrets.ssh-private-key.path} -o "StrictHostKeyChecking=no" -p 23231 localhost settings anon-access no-access
        ${pkgs.openssh}/bin/ssh -i ${config.age.secrets.ssh-private-key.path} -o "StrictHostKeyChecking=no" -p 23231 localhost users create voidbook -a '-k "${voidBookPublicKey}"'
        ${pkgs.openssh}/bin/ssh -i ${config.age.secrets.ssh-private-key.path} -o "StrictHostKeyChecking=no" -p 23231 localhost users delete admin
      '';
    };
  };
  options = { };
}
