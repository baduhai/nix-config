{ config, lib, ... }:

{
  options.services.splitDNS = {
    entries = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            domain = lib.mkOption {
              type = lib.types.str;
              description = "The domain name to configure";
            };
            lanIP = lib.mkOption {
              type = lib.types.str;
              description = "IP address to return for LAN requests";
            };
            tailscaleIP = lib.mkOption {
              type = lib.types.str;
              description = "IP address to return for Tailscale requests";
            };
          };
        }
      );
      default = [ ];
      description = "List of domains to configure for split DNS";
    };
  };
}
