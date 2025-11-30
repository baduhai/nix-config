# Shared service definitions for cross-host configuration
{
  # Host IP definitions
  hosts = {
    alexandria = {
      lanIP = "192.168.15.142";
      tailscaleIP = "100.76.19.50";
    };
    trantor = {
      tailscaleIP = "100.108.5.90";
    };
  };

  # Service definitions - IPs are inherited from host
  services = [
    {
      name = "kanidm";
      domain = "auth.baduhai.dev";
      host = "alexandria";
    }
    {
      name = "vaultwarden";
      domain = "pass.baduhai.dev";
      host = "alexandria";
    }
    {
      name = "forgejo";
      domain = "git.baduhai.dev";
      host = "trantor";
      public = true;
    }
    {
      name = "nextcloud";
      domain = "cloud.baduhai.dev";
      host = "alexandria";
    }
    {
      name = "jellyfin";
      domain = "jellyfin.baduhai.dev";
      host = "alexandria";
    }
  ];
}
