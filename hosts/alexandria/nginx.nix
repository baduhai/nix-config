{ config, lib, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "baduhai@proton.me";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare.path;
    };
    certs."baduhai.dev" = {
      extraDomainNames = [ "*.baduhai.dev" ];
    };
  };

  age.secrets.cloudflare = {
    file = ../../secrets/cloudflare.age;
    owner = "nginx";
    group = "nginx";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts =
      let
        commonVHostConfig = {
          useACMEHost = "baduhai.dev";
          forceSSL = true;
          kTLS = true;
        };
      in
      lib.mapAttrs (_: lib.recursiveUpdate commonVHostConfig) {
        "_".locations."/".return = "444";
        "cloud.baduhai.dev" = { };
        "git.baduhai.dev".locations."/".proxyPass =
          "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
        "jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:8096/";
        "office.baduhai.dev".locations."/" = {
          proxyPass = "http://unix:/run/coolwsd/coolwsd.sock";
          proxyWebsockets = true;
        };
        "pass.baduhai.dev".locations."/".proxyPass =
          "http://unix:${config.services.vaultwarden.config.ROCKET_ADDRESS}:/";
        "speedtest.baduhai.dev".locations."/".proxyPass = "http://librespeed:80/";
      };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
