{ config, pkgs, libs, ... }:

{
  age.secrets.cloudflare-dns-api-key.file = ../../../secrets/cloudflare-dns-api-key.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "baduhai@proton.me";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-dns-api-key.path;
    };
    certs."baduhai.me" = {
      extraDomainNames = "*.baduhai.me";
    };
  };
}
