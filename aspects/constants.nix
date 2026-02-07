{ lib, config, ... }:

let
  # Host submodule type
  hostType = lib.types.submodule {
    options = {
      lanIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "LAN IP address for the host";
      };
      tailscaleIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Tailscale IP address for the host";
      };
    };
  };

  # Service submodule type
  serviceType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Service name";
      };
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name for the service";
      };
      host = lib.mkOption {
        type = lib.types.str;
        description = "Host where the service runs";
      };
      public = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the service is publicly accessible";
      };
      lanIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "LAN IP address (inherited from host)";
      };
      tailscaleIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Tailscale IP address (inherited from host)";
      };
    };
  };

  # Import shared data (also used by terranix)
  sharedData = import ../data/services.nix;

  # Enrich services with host IP information
  enrichServices = hosts: services:
    map (svc:
      let
        hostInfo = hosts.${svc.host} or {};
      in
      svc // {
        lanIP = hostInfo.lanIP or null;
        tailscaleIP = hostInfo.tailscaleIP or null;
      }
    ) services;

in
{
  options.flake = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf hostType;
      default = {};
      description = "Host definitions with IP addresses";
    };

    services = lib.mkOption {
      type = lib.types.listOf serviceType;
      default = [];
      description = "Service definitions with enriched host information";
    };

    lib = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = {};
      description = "Utility functions for flake configuration";
    };
  };

  config.flake = {
    hosts = sharedData.hosts;

    services = enrichServices config.flake.hosts sharedData.services;

    lib = {
      # Nginx virtual host utilities
      mkNginxVHosts = { domains }:
        let
          mkVHostConfig = domain: vhostConfig:
            lib.recursiveUpdate {
              useACMEHost = domain;
              forceSSL = true;
              kTLS = true;
            } vhostConfig;
        in
        lib.mapAttrs mkVHostConfig domains;

      # Split DNS utilities for unbound
      # Generates unbound view config from a list of DNS entries
      mkSplitDNS = entries:
        let
          tailscaleData = map (e: ''"${e.domain}. IN A ${e.tailscaleIP}"'') entries;
          lanData = map (e: ''"${e.domain}. IN A ${e.lanIP}"'') entries;
        in
        [
          {
            name = "tailscale";
            view-first = true;
            local-zone = ''"baduhai.dev." transparent'';
            local-data = tailscaleData;
          }
          {
            name = "lan";
            view-first = true;
            local-zone = ''"baduhai.dev." transparent'';
            local-data = lanData;
          }
        ];
    };
  };
}
