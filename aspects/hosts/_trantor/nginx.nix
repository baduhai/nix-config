{
  config,
  lib,
  inputs,
  ...
}:

let
  services = inputs.self.services;

  localDomains = lib.unique (map (s: s.domain) (lib.filter (s: s.host == "trantor") services));

  acmeCerts = lib.genAttrs localDomains (domain: {
    group = "nginx";
  });
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
    certs = acmeCerts;
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "_" = {
        default = true;
        locations."/".return = "444";
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  age.secrets.cloudflare = {
    file = "${inputs.self}/secrets/cloudflare.age";
    owner = "nginx";
    group = "nginx";
  };
}
