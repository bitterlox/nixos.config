{ pkgs, config, lib, ... }:
let cfg = config.firefly-iii;
in {
  options.firefly-iii = {
    enable = lib.mkEnableOption "firefly-iii";
    user = lib.mkOption {
      type = lib.types.str;
      example = "foo";
      description = lib.mdDoc "user under which to run firefly-iii";
    };
    virtualHost = lib.mkOption {
      type = lib.types.str;
      example = "example.com";
      description = lib.mdDoc "external address for firefly-iii";
    };
    bind-address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
      description = lib.mdDoc "address for mysql to bind to";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3306;
      example = "3306";
      description = lib.mdDoc "port for mysql to listen on";
    };
    databaseName = lib.mkOption {
      type = lib.types.str;
      default = "firefly";
      example = "firefly";
      description = lib.mdDoc
        "name for mysql database to be created and used by firefly-iii";
    };
    mysqlUser = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "127.0.0.1";
      description = lib.mdDoc "name for mysql user";
    };
  };
  config = lib.mkIf cfg.enable {
    services.firefly-iii = {
      enable = true;
      user = cfg.user;
      settings = {
        APP_ENV = "production";
        APP_KEY_FILE = "/var/secrets/firefly-iii-app-key.txt";
        SITE_OWNER = "admin@sietch";
        DB_CONNECTION = "mysql";
        DB_HOST = cfg.bind-address;
        DB_PORT = cfg.port;
        DB_DATABASE = cfg.databaseName;
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = "/var/secrets/firefly-iii-mysql-password.txt";
      };
      enableNginx = true;
      virtualHost = cfg.virtualHost;
    };
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings.mysqld = {
        bind-address = cfg.bind-address;
        port = cfg.port;
      };
      initialDatabases = [{ name = cfg.databaseName; }];
      ensureUsers = [{
        name = cfg.mysqlUser;
        ensurePermissions = { "${cfg.databaseName}.*" = "ALL PRIVILEGES"; };
      }];
    };
    services.mysqlBackup = {
      enable = true;
      user = "backup";
      calendar = "weekly";
      databases = [ cfg.databaseName ];
      # figure out if this takes a toll on server resources
      singleTransaction = true;
    };
  };
}
