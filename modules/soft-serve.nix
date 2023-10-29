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
  ssh-command = ''
    ${pkgs.openssh}/bin/ssh \
    -i ${config.age.secrets.ssh-private-key.path} \
    -o "StrictHostKeyChecking=no" \
    -p 23231 \
    localhost \
  '';
in {
  imports = [ ];
  config = {
    networking.firewall.allowedTCPPorts = [ 23231 ];
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
        ${ssh-command} settings allow-keyless false
        ${ssh-command} settings anon-access no-access
        ${ssh-command} users create voidbook -a '-k "${voidBookPublicKey}"'
        ${ssh-command} users delete admin
      '';
    };
  };
  options = { };
}
