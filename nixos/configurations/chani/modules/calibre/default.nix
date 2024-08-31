{ config, options, pkgs, lib, ... }:
let
  cfg = config.customServices.calibre;
  calibreHost = "127.0.0.1";
  calibrePort = 7001;
in {
  options = {
    customServices.calibre = {
      enable = lib.mkEnableOption "calibre content server";
      virtualHost = lib.mkOption {
        type = lib.types.str;
        example =
          "{ firefly-iii = 'ff.example.com'; data-importer = 'di.example.com'; }";
        description =
          lib.mdDoc "external addresses for firefly-iii and the data-importer";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy = {
      enable = true;
      # there is an issue with the mimetype of files and the
      # X-Content-Type-Options header; figure out if it's set by default 
      # or what, and then disable it;
      # edit: issue fixed itself, header is no longer present... idk 
      virtualHosts."${cfg.virtualHost}".extraConfig = ''
        reverse_proxy ${calibreHost}:${builtins.toString calibrePort}
      '';
      # disabled http basic auth for now, letting calibre handle it downstream
      # it did auth correctly but i'm worried for stuff like opds it doesn't work
      # with http auth; didn't test it tho also didn't test if the header 
      # worked but i think it did
      #virtualHosts."${cfg.virtualHost}".extraConfig = ''
      #  reverse_proxy ${calibreHost}:${builtins.toString calibrePort}
      #  import ${config.lockbox.calibreCaddyConfPath}
      #  header {
      #    +X-AUTHED-USER {http.auth.user.id}
      #  }
      #'';
    };
    services.calibre-web = {
      enable = true;
      listen = {
        ip = calibreHost;
        port = calibrePort;
      };
      options = {
        # this folder's perms need to be calibre-web:calibre-web
        calibreLibrary = "/srv/calibre/libraries/1";
        enableBookUploading = true;
        enableKepubify = true;
        enableBookConversion = true;
        reverseProxyAuth = {
          enable = true;
          header = "X-AUTHED-USER";
        };
      };
    };
  };
}

