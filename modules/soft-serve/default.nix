{ pkgs, config, ssh-public-keys, ... }:
let
  lib = pkgs.lib;
  adminKey = pkgs.writeText "soft-serve-admin-key"
    (builtins.getAttr "sietch" ssh-public-keys);

  wrapped-soft-serve = import ./wrap-soft-serve.nix {
    inherit pkgs adminKey;
    inherit (config.soft-serve) dataPath ports;
  };

  postStart = import ./build-post-start.nix {
    inherit pkgs;
    ssh-private-key-path = config.age.secrets.ssh-private-key.path;
    soft-serve-config = config.soft-serve;
  };

in {
  imports = [ ];
  config = {
    networking.firewall.allowedTCPPorts = with config.soft-serve.ports; [
      ssh
      http
      git
    ];
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
        ExecStart = "${wrapped-soft-serve}/bin/soft serve";
      };
      wantedBy = [ "multi-user.target" ];
      inherit postStart;
      #postStart = lib.debug.traceSeq postStart postStart;
    };
  };
  options = let
    mkPortOption = default: description:
      lib.mkOption {
        type = lib.types.port;
        default = default;
        example = "${default}";
        description = lib.mdDoc description;
      };
  in {
    soft-serve = {
      dataPath = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/soft-serve";
        example = "/var/lib/soft-serve";
        description = lib.mdDoc
          "Absolute path which will be passed to SOFT_SERVE_DATA_PATH env var";
      };
      ports = {
        ssh = mkPortOption 23231 "Port for ssh server";
        http = mkPortOption 23232 "Port for http server";
        git = mkPortOption 9418 "Port for git daemon";
      };
      adminPublicKeys = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = { foo = "ssh-ed25519 AAAAC....."; };
        description = lib.mdDoc
          "An attrSet of public keys for which we'll create admin users using the attribute name as username";
      };
      # todo: set up userPublicKeys... should be trivial
    };
  };
}
