{
  config,
  lib,
  inputs,
  ...
}:

let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
in

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

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = mkNginxVHosts {
      acmeHost = "baduhai.dev";
      domains."_".locations."/".return = "444";
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  age.secrets.cloudflare = {
    file = ../../secrets/cloudflare.age;
    owner = "nginx";
    group = "nginx";
  };
}
