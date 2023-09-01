{ inputs, config, pkgs, lib, ... }:

{
  services = {
    bazarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    jackett.enable = true;

    qbittorrent = {
      enable = true;
      user = "user";
      group = "hosted";
      port = lib.toInt "${config.ports.qbittorrent}";
    };

    radarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    sonarr = {
      enable = true;
      user = "user";
      group = "hosted";
    };

    nginx.virtualHosts = {
      "bazarr.baduhai.dev" = {
        useACMEHost = "baduhai.dev";
        forceSSL = true;
        kTLS = true;
        locations."/".proxyPass = "http://127.0.0.1:${config.ports.bazaar}";
      };
      "jackett.baduhai.dev" = {
        useACMEHost = "baduhai.dev";
        forceSSL = true;
        kTLS = true;
        locations."/".proxyPass = "http://127.0.0.1:${config.ports.jackett}";
      };
      "qbittorrent.baduhai.dev" = {
        useACMEHost = "baduhai.dev";
        forceSSL = true;
        kTLS = true;
        locations."/".proxyPass =
          "http://127.0.0.1:${config.ports.qbittorrent}";
      };
      "radarr.baduhai.dev" = {
        useACMEHost = "baduhai.dev";
        forceSSL = true;
        kTLS = true;
        locations."/".proxyPass = "http://127.0.0.1:${config.ports.radarr}";
      };
      "sonarr.baduhai.dev" = {
        useACMEHost = "baduhai.dev";
        forceSSL = true;
        kTLS = true;
        locations."/".proxyPass = "http://127.0.0.1:${config.ports.sonarr}";
      };
    };
  };
}
