{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.customServices.urbit;
  urbitHost = "127.0.0.1";
  types = lib.types;
  mkSystemdService = name: port: pierPath: {
    description = "service running urbit ship ${name}";

    # Start after the network is up
    after = [ "default.target" ];

    # Make sure the service is started after boot
    wantedBy = [ "default.target" ];

    # Environment settings
    environment = {
      # You might want to add environment variables here if needed
    };

    serviceConfig = {
      # The actual command to run
      ExecStart = "${lib.getExe pkgs.urbit} ${pierPath} --http-port ${builtins.toString port} -t";

      # For clean shutdown, we should specify the termination signal
      KillSignal = "SIGTERM";

      # Give the service some time to shut down gracefully
      TimeoutStopSec = "30s";

      # Restart on failure
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
  optionType = types.submodule {
    options = {
      enable = lib.mkEnableOption "enable running of this moon";
      virtualHost = lib.mkOption {
        type = lib.types.str;
        example = "sampel-palnet.example.com";
        description = lib.mdDoc "url the moon will be served at";
      };
      # TODO: mkPortOption needs to be in a lib
      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        example = "8080";
        description = lib.mdDoc "port where the moon runs";
      };
      pierPath = lib.mkOption {
        type = lib.types.path;
        description = lib.mdDoc "path to the pier";
      };
    };
  };
  enabledMoonAttrs = (
    lib.attrsets.filterAttrs (key: val: val.enable == true) (
      lib.mapAttrs (
        id:
        attrs@{
          enable,
          virtualHost,
          port,
          pierPath,
          ...
        }:
        { name = id; } // attrs
      ) cfg
    )
  );
  enabledMoonList = builtins.attrValues (enabledMoonAttrs);
in
{
  options = {
    customServices.urbit = lib.mkOption {
      type = types.attrsOf optionType;
      default = { };
      description = "Configure and run an urbit moon";
    };
  };

  # urbit ports explainer:
  # https://github.com/urbit/urbit/issues/1268#issuecomment-488755907

  # open ports for caddy
  config.networking.firewall.allowedUDPPorts = (builtins.map ({ port, ... }: port) enabledMoonList);

  config.systemd.user.services = lib.mapAttrs (
    id:
    attrs@{
      enable,
      virtualHost,
      port,
      pierPath,
      ...
    }:
    mkSystemdService id port pierPath
  ) enabledMoonAttrs;

  config.services.caddy = lib.mkMerge (
    builtins.map (
      { virtualHost, port, ... }:
      {
        enable = true;
        # there is an issue with the mimetype of files and the
        # X-Content-Type-Options header; figure out if it's set by default
        # or what, and then disable it;
        # edit: issue fixed itself, header is no longer present... idk
        virtualHosts."${virtualHost}".extraConfig = ''
          reverse_proxy ${urbitHost}:${builtins.toString port}
        '';

      }
    ) enabledMoonList
  );

  # open ports for urbit
  config.networking.firewall.allowedTCPPortRanges =
    let
      len = builtins.length enabledMoonList;
    in
    lib.mkIf (len > 0) [
      {
        from = 12321;
        to = 12321 + (len - 1);
      }
    ];
}
