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
  imports = [ (inputs.fusion.nixosModules.default { self = inputs.fusion; }) ];

  services = {
    fusion = {
      enable = true;
      port = 58000;
      allowPrivateFeeds = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev".locations."/".proxyPass = "http://localhost:58000/";
    };
  };

  environment.persistence.main.directories = [
    {
      directory = "/var/lib/fusion";
      mode = "0700";
    }
  ];

  systemd.services.fusion.serviceConfig = {
    PrivateMounts = lib.mkForce false;
    ProtectSystem = lib.mkForce false;
  };
}
