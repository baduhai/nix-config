{ config, pkgs, libs, ... }:

{
  age.secrets.cloudflare-creds.file = ../../../secrets/cloudflare-creds.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "baduhai@proton.me";
      dnsResolver = "100.100.100.100:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-creds.path;
    };
    certs."baduhai.me" = {
      extraDomainNames = [ "*.baduhai.me" ];
    };
  };
}
