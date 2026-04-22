{
  config,
  lib,
  ...
}:

{
  services.pocket-id = {
    enable = true;
    environmentFile = "/etc/nixos/secrets/pocket-id.key";
    settings = {
      APP_URL = "https://auth.baduhai.dev";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
    };
  };
}
