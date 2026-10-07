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
    domains."rss.baduhai.dev".locations."/".proxyPass = "http://10.233.3.2:58000/";
  };

  containers.fusion = mkContainer {
    index = 3;
    specialArgs = { inherit inputs; };
    config =
      { lib, inputs, ... }:
      {
        imports = [ (inputs.fusion.nixosModules.default { self = inputs.fusion; }) ];

        # uid/gid pinned to the host's existing on-disk ownership so the moved
        # data keeps its owner without a recursive chown.
        users = {
          users.fusion = {
            isSystemUser = true;
            group = "fusion";
            uid = 988;
          };
          groups.fusion.gid = 985;
        };

        services.fusion = {
          enable = true;
          port = 58000;
          allowPrivateFeeds = true;
        };

        systemd.services.fusion.serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = "fusion";
          Group = "fusion";
          PrivateMounts = lib.mkForce false;
          ProtectSystem = lib.mkForce false;
        };

        systemd.services.fusion.environment.FUSION_ALLOW_EMPTY_PASSWORD = "true";
      };
  };
}
