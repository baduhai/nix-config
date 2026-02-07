{ inputs, lib, ... }:

let
  utils = import ../../../utils.nix { inherit inputs lib; };
in

{
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
        local-data = map (e: ''"${e.domain}. IN A ${e.lanIP}"'')
          (lib.filter (e: e ? lanIP) utils.services);
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

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
