{ config, lib, ... }:
let
  cfg = config.customServices.urbit;
  urbitHost = "127.0.0.1";
in {
  options = {
    customServices.urbit = {
      enable = lib.mkEnableOption "enable running of an urbit moon";
      moon1virtualHost = lib.mkOption {
        type = lib.types.str;
        example = "sampel-palnet.example.com";
        description =
          lib.mdDoc "external addresses for firefly-iii and the data-importer";
      };
      # TODO: mkPortOption needs to be in a lib 
      moon1Port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        example = "8080";
        description = lib.mdDoc "port where the moon runs";
      };
      moon2virtualHost = lib.mkOption {
        type = lib.types.str;
        example = "sampel-palnet.example.com";
        description =
          lib.mdDoc "external addresses for firefly-iii and the data-importer";
      };
      moon2Port = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        example = "8081";
        description = lib.mdDoc "port where the moon runs";
      };
    };
  };
  config = lib.mkIf cfg.enable {
     # why??
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy = {
      enable = true;
      # there is an issue with the mimetype of files and the
      # X-Content-Type-Options header; figure out if it's set by default 
      # or what, and then disable it;
      # edit: issue fixed itself, header is no longer present... idk 
      virtualHosts."${cfg.moon1virtualHost}".extraConfig = ''
        reverse_proxy ${urbitHost}:${builtins.toString cfg.moon1Port}
      '';
      virtualHosts."${cfg.moon1virtualHost}".extraConfig = ''
        reverse_proxy ${urbitHost}:${builtins.toString cfg.moon2Port}
      '';
    };
  };
}

