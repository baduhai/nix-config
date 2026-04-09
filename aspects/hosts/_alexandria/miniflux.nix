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
  services = {
    miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "/run/miniflux/miniflux.sock";
        CREATE_ADMIN = 1;
      };
      adminCredentialsFile = config.age.secrets.miniflux-admincreds.path;
      createDatabaseLocally = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev" = {
        locations."/".proxyPass = "http://unix:/run/miniflux/miniflux.sock:/";
      };
    };
  };

  users.users.nginx.extraGroups = [ "miniflux" ];

  age.secrets.miniflux-admincreds = {
    file = "${inputs.self}/secrets/miniflux-admincreds.age";
    owner = "miniflux";
    group = "miniflux";
  };
}
