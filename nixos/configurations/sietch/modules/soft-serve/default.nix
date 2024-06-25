{ pkgs, config, ... }:
let
  cfg = config.soft-serve;
  lib = pkgs.lib;
  adminKey = pkgs.writeText "soft-serve-admin-key" config.sshPubKeys.sietch;

  wrapped-soft-serve = import ./wrap-soft-serve.nix {
    inherit pkgs adminKey;
    inherit (config.soft-serve) dataPath ports sshPublicUrl;
  };

  configureScript = import ./build-configure-script.nix {
    inherit pkgs;
    ssh-private-key-path = config.lockbox.sshKeyPath;
    soft-serve-config = config.soft-serve;
  };

in {
  imports = [ ];
  options = let
    mkPortOption = default: description:
      lib.mkOption {
        type = lib.types.port;
        default = default;
        example = "${default}";
        description = lib.mdDoc description;
      };
  in {
    enable = lib.mkEnableOption "soft-serve";
    soft-serve = {
      dataPath = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/soft-serve";
        example = "/var/lib/soft-serve";
        description = lib.mdDoc
          "Absolute path which will be passed to SOFT_SERVE_DATA_PATH env var";
      };
      sshPublicUrl = lib.mkOption {
        type = lib.types.str;
        default = "localhost:23231";
        example = "localhost:23231";
        description = lib.mdDoc "Url to clone repos over ssh";
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
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = with config.soft-serve.ports; [
      ssh
      http
      git
    ];
    systemd.services.soft-serve = {
      stopIfChanged = true;
      restartIfChanged = true;
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
    };
    # we run the configure in a different systemd unit because running it
    # as 'postStart' of the soft-serve unit caused a wierd issue with SQLITE
    # where it would error out saying the db was locked
    systemd.services.configure-soft-serve = {
      unitConfig = {
        Description = "Soft Serve configure commands";
        Requires = "soft-serve.service";
        After = "soft-serve.service";
      };
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.writeShellScript "configure-soft-serve" configureScript}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
