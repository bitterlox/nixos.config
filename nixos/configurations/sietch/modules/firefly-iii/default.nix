{ pkgs, config, lib, ... }:
# state created by this module:
# - /var/lib/firefly-iii 
# - /var/lib/caddy
# - /var/lib/mysql
# - ...?
# state we need to create manually for this to work
# - /var/secrets/firefly-iii-app-key.txt
let
  cfg = config.firefly-iii;
  # this username will be used to create a user under which we'll run 
  # firefly-iii, caddy and everything else;
  # i tried to have firefly-iii use its own user account but was getting perm
  # issues so now everything runs under the "caddy" account
  # if switching this in the future remember that caddy itself isn't being
  # congured for account currently, we're relying on the fact that is uses a
  # "caddy" account on it own
  defaultUsername = "caddy";
in {
  imports = [ ./firefly-iii-data-importer.nix ];
  options.firefly-iii = {
    enable = lib.mkEnableOption "firefly-iii";
    dataImporterPackage = lib.mkOption {
      type = lib.types.package;
      description = ''
        The firefly-iii-data-importer package served by php-fpm and the webserver of choice.
        This option can be used to point the webserver to the correct root.
      '';
    };
    virtualHosts = lib.mkOption {
      type = let virtualHostOption = lib.mkOption { type = lib.types.str; };
      in lib.types.submodule {
        options.firefly-iii = virtualHostOption;
        options.data-importer = virtualHostOption;
      };
      example =
        "{ firefly-iii = 'ff.example.com'; data-importer = 'di.example.com'; }";
      description =
        lib.mdDoc "external addresses for firefly-iii and the data-importer";
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
      default = "fireflydb";
      example = "fireflydb";
      description = lib.mdDoc
        "name for mysql database to be created and used by firefly-iii";
    };
  };
  config = lib.mkIf cfg.enable {
    # open firewall for caddy
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.firefly-iii = {
      enable = true;
      user = defaultUsername;
      settings = {
        APP_ENV = "production";
        # probably the only piece of state to add manually
        APP_KEY_FILE = "/var/secrets/firefly-iii-app-key.txt";
        SITE_OWNER = "admin@sietch";
        DB_CONNECTION = "mysql";
        DB_HOST = cfg.bind-address;
        DB_PORT = cfg.port;
        DB_DATABASE = cfg.databaseName;
        DB_USERNAME = defaultUsername;
        DB_SOCKET = "/run/mysqld/mysqld.sock";
      };
      enableNginx = false;
      virtualHost = cfg.virtualHosts.firefly-iii;
    };
    customServices.firefly-iii-data-importer = {
      enable = true;
      package = cfg.dataImporterPackage;
      settings = {
          FIREFLY_III_URL = "https://${cfg.virtualHosts.firefly-iii}";
          FIREFLY_III_ACCESS_TOKEN_FILE = "/var/secrets/firefly-iii-data-importer-token.txt";
        };
    };
    services.phpfpm.settings = { log_level = "debug"; };
    services.caddy = {
      #user = defaultUsername;
      enable = true;
      # there is an issue with the mimetype of files and the
      # X-Content-Type-Options header; figure out if it's set by default 
      # or what, and then disable it;
      # edit: issue fixed itself, header is no longer present... idk 
      virtualHosts."${cfg.virtualHosts.firefly-iii}".extraConfig = ''
        encode gzip
        file_server
        root * ${config.services.firefly-iii.package}/public
        php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket}
      '';

      virtualHosts."${cfg.virtualHosts.data-importer}".extraConfig = ''
        encode gzip
        file_server
        root * ${cfg.dataImporterPackage}/public
        php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii-data-importer.socket}
      '';
    };
    # using socket authentication means that we need to authenticate from a user
    # account whose name is the same as the mysql user we're authenticating for
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings.mysqld = {
        bind-address = cfg.bind-address;
        port = cfg.port;
      };
      initialDatabases = [{ name = cfg.databaseName; }];
      ensureUsers = [{
        name = defaultUsername;
        ensurePermissions = { "${cfg.databaseName}.*" = "ALL PRIVILEGES"; };
      }];
    };
    services.mysqlBackup = {
      enable = true;
      user = "angel";
      calendar = "weekly";
      databases = [ cfg.databaseName ];
      # figure out if this takes a toll on server resources
      singleTransaction = true;
    };
  };
}
