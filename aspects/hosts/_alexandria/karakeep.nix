{
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services.karakeep = {
    enable = true;
    meilisearch.enable = true;
    extraEnvironment = {
      PORT = "58223";
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."read.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:58223/";
  };
}
