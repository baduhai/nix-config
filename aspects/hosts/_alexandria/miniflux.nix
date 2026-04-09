{ config, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services = {
    miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:8080";
        CREATE_ADMIN = 1;
      };
      adminCredentialsFile = config.age.secrets.miniflux-admincreds.path;
      createDatabaseLocally = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev" = {
        locations."/".proxyPass = "http://${config.services.miniflux.config.LISTEN_ADDR}/";
      };
    };
  };

  age.secrets.miniflux-admincreds = {
    file = "${inputs.self}/secrets/miniflux-admincreds.age";
    owner = "miniflux";
    group = "miniflux";
  };
}
