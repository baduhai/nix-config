{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services.nginx = {
    enable = true;
    group = "hosted";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; root = inputs.homepage; };
      "bazarr.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.bazaar}"; };
      "bitwarden.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.vaultwarden}"; };
      "cinny.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.cinny}"; };
      "detect.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.changedetection-io}"; };
      "jackett.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.jackett}"; };
      "jellyfin.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.jellyfin}"; };
      "librespeed.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.librespeed}"; };
      "n8n.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.n8n}"; };
      "paperless.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.paperless}"; };
      "qbittorrent.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.qbittorrent}"; };
      "radarr.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.radarr}"; };
      "shiori.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.shiori}"; };
      "sonarr.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.sonarr}"; };
      "sync.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.syncthing}"; };
      "whoogle.baduhai.me" = { useACMEHost = "baduhai.me"; forceSSL = true; kTLS = true; locations."/".proxyPass = "http://127.0.0.1:${config.ports.whoogle}"; };
    };
  };
}
