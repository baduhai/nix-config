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
    freshrss = {
      enable = true;
      defaultUser = "admin";
      passwordFile = config.age.secrets.freshrss-adminpass.path;
      baseUrl = "https://rss.baduhai.dev";
      dataDir = "/data/freshrss";
      webserver = "nginx";
      virtualHost = "rss.baduhai.dev";
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev" = { };
    };
  };

  age.secrets.freshrss-adminpass = {
    file = "${inputs.self}/secrets/freshrss-adminpass.age";
    owner = "freshrss";
    group = "freshrss";
  };
}
