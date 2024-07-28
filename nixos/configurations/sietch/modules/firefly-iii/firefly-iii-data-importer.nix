{ pkgs, config, lib, ... }:

let
  inherit (lib) mkIf mkOption mkEnableOption literalExpression;
  inherit (lib.types) attrsOf oneOf str int bool path package submodule;
  inherit (lib.strings) concatLines toShellVars removeSuffix hasSuffix;
  inherit (lib.attrsets)
    mapAttrsToList genAttrs filterAttrs mapAttrs' nameValuePair;

  firefly-iii-cfg = config.services.firefly-iii;
  cfg = config.customServices.firefly-iii-data-importer;

  firefly-iii-user = firefly-iii-cfg.user;
  firefly-iii-group = firefly-iii-cfg.group;

  artisan = "${cfg.package}/artisan";

  env-file-values = mapAttrs' (n: v: nameValuePair (removeSuffix "_FILE" n) v)
    (filterAttrs (n: v: hasSuffix "_FILE" n) cfg.settings);
  env-nonfile-values = filterAttrs (n: v: !hasSuffix "_FILE" n) cfg.settings;

  fileenv-func = ''
    set -a
    ${toShellVars env-nonfile-values}
    ${concatLines (mapAttrsToList (n: v: ''${n}="$(< ${v})"'') env-file-values)}
    set +a
  '';

  # one of the artisan commands imports the env vars into the php process
  # or in the config, idk which
  firefly-iii-maintenance =
    pkgs.writeShellScript "firefly-iii-maintenance.sh" ''
      ${fileenv-func}

      ${artisan} package:discover
      ${artisan} cache:clear
      ${artisan} config:cache
      ${artisan} importer:version
    '';

  commonServiceConfig = {
    Type = "oneshot";
    User = firefly-iii-user;
    Group = firefly-iii-group;
    StateDirectory = "firefly-iii-data-importer";
    ReadWritePaths = [ cfg.dataDir ];
    WorkingDirectory = cfg.package;
    PrivateTmp = true;
    PrivateDevices = true;
    CapabilityBoundingSet = "";
    AmbientCapabilities = "";
    ProtectSystem = "strict";
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectHome = "tmpfs";
    ProtectKernelLogs = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateNetwork = false;
    RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
    SystemCallArchitectures = "native";
    SystemCallFilter =
      [ "@system-service @resources" "~@obsolete @privileged" ];
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    NoNewPrivileges = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    LockPersonality = true;
    PrivateUsers = true;
  };

in {

  options.customServices.firefly-iii-data-importer = {

    enable = mkEnableOption
      "Firefly III: A free and open source personal finance manager";

    dataDir = mkOption {
      type = path;
      default = "/var/lib/firefly-iii-data-importer";
      description = ''
        The place where the data importer stores its state.
      '';
    };

    package = mkOption {
      type = package;
      defaultText = literalExpression "pkgs.firefly-iii-data-importer";
      description = ''
        The firefly-iii package served by php-fpm and the webserver of choice.
        This option can be used to point the webserver to the correct root. It
        may also be used to set the package to a different version, say a
        development version.
      '';
      apply = firefly-iii-data-importer:
        firefly-iii-data-importer.override (prev: { dataDir = cfg.dataDir; });
    };

    poolConfig = mkOption {
      type = attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the data importer PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Options for firefly-iii configuration. Refer to
        <https://github.com/firefly-iii/firefly-iii/blob/main/.env.example> for
        details on supported values. All <option>_FILE values supported by
        upstream are supported here.

        APP_URL will be the same as `services.firefly-iii.virtualHost` if the
        former is unset in `services.firefly-iii.settings`.
      '';
      type = submodule {
        freeformType = attrsOf (oneOf [ str int bool ]);
        options = {
          FIREFLY_III_URL = mkOption {
            type = str;
            example = "ff.example.com";
            description = ''
              The url where firefly-iii is served.
            '';
          };
          FIREFLY_III_CLIENT_ID_FILE = mkOption {
            type = str;
            description = ''
              OAuth client id to connect to the firefly-iii api.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.phpfpm.pools.firefly-iii-data-importer = {
      group = firefly-iii-group;
      user = firefly-iii-user;
      phpPackage = cfg.package.phpPackage;
      phpOptions = ''
        log_errors = on
      '';
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = firefly-iii-user;
        "listen.group" = firefly-iii-group;
        "clear_env" = "no";
      } // cfg.poolConfig;
    };

    systemd.services.firefly-iii-data-importer-setup = {
      after = [ "postgresql.service" "mysql.service" ];
      requiredBy = [ "phpfpm-firefly-iii-data-importer.service" ];
      before = [ "phpfpm-firefly-iii-data-importer.service" ];
      serviceConfig = {
        ExecStart = firefly-iii-maintenance;
        RemainAfterExit = true;
      } // commonServiceConfig;
      unitConfig.JoinsNamespaceOf = "phpfpm-firefly-iii-data-importer.service";
      restartTriggers = [ cfg.package ];
    };

    systemd.tmpfiles.settings."10-firefly-iii-data-importer" = genAttrs [
      "${cfg.dataDir}/storage"
      "${cfg.dataDir}/storage/app"
      "${cfg.dataDir}/storage/database"
      "${cfg.dataDir}/storage/export"
      "${cfg.dataDir}/storage/framework"
      "${cfg.dataDir}/storage/framework/cache"
      "${cfg.dataDir}/storage/framework/sessions"
      "${cfg.dataDir}/storage/framework/views"
      "${cfg.dataDir}/storage/logs"
      "${cfg.dataDir}/storage/uploads"
      "${cfg.dataDir}/cache"
    ] (n: {
      d = {
        group = firefly-iii-group;
        mode = "0700";
        user = firefly-iii-user;
      };
    }) // {
      "${cfg.dataDir}".d = {
        group = firefly-iii-group;
        mode = "0710";
        user = firefly-iii-user;
      };
    };
  };
}

