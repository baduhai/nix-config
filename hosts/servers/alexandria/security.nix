{ inputs, config, pkgs, lib, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "baduhai@proton.me";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare.path;
    };
    certs."baduhai.me" = { extraDomainNames = [ "*.baduhai.me" ]; };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare.age;
    owner = "nginx";
    group = "hosted";
  };
}
