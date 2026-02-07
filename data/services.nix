# Shared service and host definitions
# This file can be imported directly (unlike aspects which use flake-parts)
{
  hosts = {
    alexandria = {
      lanIP = "192.168.15.142";
      tailscaleIP = "100.76.19.50";
    };
    trantor = {
      tailscaleIP = "100.108.5.90";
    };
  };

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
