# Shared service definitions for cross-host configuration
# Used by:
# - alexandria: DNS server (LAN) + service hosting (vaultwarden, nextcloud, jellyfin, kanidm)
# - trantor: DNS server (Tailnet) + service hosting (forgejo)
{
  services = [
    {
      name = "kanidm";
      domain = "auth.baduhai.dev";
      host = "alexandria";
      lanIP = "192.168.15.142";
      tailscaleIP = "100.76.19.50";
      port = 8443;
    }
    {
      name = "vaultwarden";
      domain = "pass.baduhai.dev";
      host = "alexandria";
      public = true;
      lanIP = "192.168.15.142";
      tailscaleIP = "100.76.19.50";
      port = 8222;
    }
    {
      name = "forgejo";
      domain = "git.baduhai.dev";
      host = "trantor";
      public = true;
      tailscaleIP = "100.108.5.90";
      port = 3000;
    }
    {
      name = "nextcloud";
      domain = "cloud.baduhai.dev";
      host = "alexandria";
      public = true;
      lanIP = "192.168.15.142";
      tailscaleIP = "100.76.19.50";
      port = 443;
    }
    {
      name = "jellyfin";
      domain = "jellyfin.baduhai.dev";
      host = "alexandria";
      lanIP = "192.168.15.142";
      tailscaleIP = "100.76.19.50";
      port = 8096;
    }
  ];
}
