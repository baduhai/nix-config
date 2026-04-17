{ config, inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services = {
    miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:58000";
        CREATE_ADMIN = 1;
        FETCHER_ALLOW_PRIVATE_NETWORKS = 1;
        POLLING_SCHEDULER = "entry_frequency";
        SCHEDULER_ENTRY_FREQUENCY_MIN_INTERVAL = 60;
        SCHEDULER_ENTRY_FREQUENCY_MAX_INTERVAL = 10080;
      };
      adminCredentialsFile = config.age.secrets.miniflux-admincreds.path;
      createDatabaseLocally = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev".locations."/".proxyPass =
        "http://${config.services.miniflux.config.LISTEN_ADDR}/";
      domains."read.baduhai.dev".locations."/".proxyPass = "http://localhost:58001/";
    };
  };

  virtualisation.oci-containers.containers.laterfeed = {
    image = "reaperberri/laterfeed:latest";
    ports = [
      "58001:8000"
    ];
    environment = {
      PORT = "8000";
      DATABASE_URL = "sqlite:/data/data.db";
      BASE_URL = "https://read.baduhai.dev";
      AUTH_TOKEN = "changeme";
    };
    volumes = [
      "/var/lib/laterfeed:/data"
    ];
    autoStart = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/laterfeed 0755 root root -"
  ];

  age.secrets.miniflux-admincreds = {
    file = "${inputs.self}/secrets/miniflux-admincreds.age";
    owner = "miniflux";
    group = "miniflux";
  };
}
