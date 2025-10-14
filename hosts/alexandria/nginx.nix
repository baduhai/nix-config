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
        "dav.baduhai.dev".locations = {
          "/caldav" = {
            proxyPass = "http://unix:/run/radicale/radicale.sock:/";
            extraConfig = ''
              proxy_set_header X-Script-Name /caldav;
              proxy_pass_header Authorization;
            '';
          };
          "/webdav" = {
            proxyPass = "http://unix:/run/rclone-webdav/webdav.sock:/webdav/";
            extraConfig = ''
              proxy_set_header X-Script-Name /webdav;
              proxy_pass_header Authorization;
              proxy_connect_timeout 300; # Increase timeouts for large file uploads
              proxy_send_timeout 300;
              proxy_read_timeout 300;
              client_max_body_size 10G; # Allow large file uploads
              proxy_buffering off; # Buffer settings for better performance
              proxy_request_buffering off;
            '';
          };
        };
        "git.baduhai.dev".locations."/".proxyPass =
          "http://unix:${config.services.forgejo.settings.server.HTTP_ADDR}:/";
        "jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:8096/";
        "pass.baduhai.dev".locations."/".proxyPass =
          "http://unix:${config.services.vaultwarden.config.ROCKET_ADDRESS}:/";
        "speedtest.baduhai.dev".locations."/".proxyPass = "http://librespeed:80/";
      };
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
