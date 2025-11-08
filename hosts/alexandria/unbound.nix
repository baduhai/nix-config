{ config, inputs, lib, ... }:

let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkSplitDNS;
in

{
  imports = [ ../modules/split-dns.nix ];

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
          "100.64.0.0/10 allow" # Tailscale CGNAT range
          "::1/128 allow"
          "fd7a:115c:a1e0::/48 allow" # Tailscale IPv6
        ];

        # Enable views for split DNS
        access-control-view = [
          "100.64.0.0/10 tailscale"
          "fd7a:115c:a1e0::/48 tailscale"
          "192.168.0.0/16 lan"
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
      };
      # Split DNS views - automatically collected from all service files
      view = mkSplitDNS config.services.splitDNS.entries;

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
