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
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://pass.baduhai.dev";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 58222;
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."pass.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:58222/";
  };

  environment.persistence.main.directories = [
    {
      directory = "/var/lib/bitwarden_rs";
      user = "vaultwarden";
      group = "vaultwarden";
      mode = "0700";
    }
  ];

  systemd.services.vaultwarden.serviceConfig = {
    PrivateMounts = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
  };
}
