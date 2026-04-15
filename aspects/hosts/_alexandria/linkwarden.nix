{
  config,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services = {
    linkwarden = {
      enable = true;
      host = "127.0.0.1";
      port = 58223;
      enableRegistration = true;
      secretFiles.NEXTAUTH_SECRET = config.age.secrets.linkwarden-nextauth-secret.path;
      environment = {
        NEXTAUTH_URL = "https://read.baduhai.dev";
      };
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."read.baduhai.dev".locations."/".proxyPass =
        "http://${config.services.linkwarden.host}:${toString config.services.linkwarden.port}/";
    };
  };

  age.secrets.linkwarden-nextauth-secret = {
    file = "${inputs.self}/secrets/linkwarden-nextauth-secret.age";
    owner = "linkwarden";
    group = "linkwarden";
  };
}
