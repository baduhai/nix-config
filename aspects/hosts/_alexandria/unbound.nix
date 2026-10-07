{ inputs, lib, ... }:

let
  services = inputs.self.services;
  mkContainer = inputs.self.lib.mkContainer;
in

{
  # Shares the host network namespace so it keeps answering LAN/tailnet clients
  # on :53; private-network app containers reach it via their veth gateway.
  containers.unbound = mkContainer {
    privateNetwork = false;
    specialArgs = { inherit inputs; };
    config = { ... }: {
      services.unbound = {
        enable = true;
        enableRootTrustAnchor = true;
        settings = {
          server = {
            interface = [
              "0.0.0.0"
              "::"
            ];
            access-control = [
              "127.0.0.0/8 allow"
              "192.168.0.0/16 allow"
              "10.233.0.0/16 allow" # container veth gateways
              "::1/128 allow"
            ];

            num-threads = 2;
            msg-cache-size = "50m";
            rrset-cache-size = "100m";
            cache-min-ttl = 300;
            cache-max-ttl = 86400;
            prefetch = true;
            prefetch-key = true;
            hide-identity = true;
            hide-version = true;
            so-rcvbuf = "1m";
            so-sndbuf = "1m";

            # LAN-only DNS records
            local-zone = ''"baduhai.dev." transparent'';
            local-data = map (e: ''"${e.domain}. IN A ${e.lanIP}"'') (lib.filter (e: e.lanIP != null) services);
          };

          forward-zone = [
            {
              name = ".";
              forward-addr = [
                "1.1.1.1@853#cloudflare-dns.com"
                "1.0.0.1@853#cloudflare-dns.com"
              ];
              forward-tls-upstream = true;
            }
          ];
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
