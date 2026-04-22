{
  config,
  lib,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services.pocket-id = {
    enable = true;
    environmentFile = config.age.secrets.pocket-id-key.path;
    settings = {
      APP_URL = "https://auth.baduhai.dev";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."auth.baduhai.dev".locations."/".proxyPass = "http://localhost:1411/";
  };

  age.secrets.pocket-id-key = {
    file = "${inputs.self}/secrets/pocket-id.key.age";
  };

  environment.persistence.main.directories = [
    {
      directory = config.services.pocket-id.dataDir;
      inherit (config.services.pocket-id) user group;
      mode = "0700";
    }
  ];

  systemd.services.pocket-id.serviceConfig = {
    PrivateMounts = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
  };
}
