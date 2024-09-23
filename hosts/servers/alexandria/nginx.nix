{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  services.nginx = {
    enable = true;
    group = "hosted";
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      root = inputs.homepage;
    };
  };
}
