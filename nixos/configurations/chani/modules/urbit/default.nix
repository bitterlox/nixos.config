{ config, lib, ... }:
let
  cfg = config.customServices.urbit;
  urbitHost = "127.0.0.1";
  urbitPort = 8080;
in {
  options = {
    customServices.urbit = {
      enable = lib.mkEnableOption "enable running of an urbit moon";
      virtualHost = lib.mkOption {
        type = lib.types.str;
        example = "sampel-palnet.example.com";
        description =
          lib.mdDoc "external addresses for firefly-iii and the data-importer";
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
      virtualHosts."${cfg.virtualHost}".extraConfig = ''
        reverse_proxy ${urbitHost}:${builtins.toString urbitPort}
      '';
    };
  };
}

