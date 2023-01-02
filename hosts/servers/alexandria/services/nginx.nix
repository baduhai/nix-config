{ inputs, config, pkgs, libs, ... }:

{
  services.nginx = {
    enable = true;
    group = "hosted";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = let
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
    in {
      "baduhai.me".root = inputs.homepage;
      "bazarr.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:6767";
      "bitwarden.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      "cinny.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:8002";
      "detect.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:${toString config.services.changedetection-io.port}";
      "jellyfin.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:8096";
      "librespeed.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:8003";
      "n8n.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:${N8N_PORT}";
      "paperless.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
      "prowlarr.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:9696";
      "radarr.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:7878";
      "shiori.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:${toString config.services.shiori.port}";
      "sonarr.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:8989";
      "sync.baduhai.me"locations."/".proxyPass = "http://127.0.0.1:8006";
      "whoogle.baduhai.me".locations."/".proxyPass = "http://127.0.0.1:8007";
    };
  };
}
