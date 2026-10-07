{
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
  mkContainer = inputs.self.lib.mkContainer;
in

{
  services.nginx.virtualHosts = mkNginxVHosts {
    domains."auth.baduhai.dev".locations."/".proxyPass = "http://10.233.4.2:1411/";
  };

  age.secrets.pocket-id-key = {
    file = "${inputs.self}/secrets/pocket-id.key.age";
  };

  containers.pocket-id = mkContainer {
    index = 4;
    config = { ... }: {
      # uid/gid pinned to the host's existing on-disk ownership so the moved
      # data keeps its owner without a recursive chown.
      users = {
        users."pocket-id".uid = 992;
        groups."pocket-id".gid = 990;
      };
      services.pocket-id = {
        enable = true;
        environmentFile = "/run/agenix/pocket-id-key";
        settings = {
          APP_URL = "https://auth.baduhai.dev";
          TRUST_PROXY = true;
          ANALYTICS_DISABLED = true;
          EMAILS_VERIFIED = true;
        };
      };
    };
  };
}
