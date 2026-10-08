{ inputs, ... }:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
  mkContainer = inputs.self.lib.mkContainer;
in

{
  services.nginx.virtualHosts = mkNginxVHosts {
    domains."search.baduhai.dev" = {
      locations."/" = {
        proxyPass = "http://10.233.7.2:4444/";
        # degoog pushes results/store progress over SSE and uses websockets,
        # neither of which recommendedProxySettings upgrades or unbuffers.
        proxyWebsockets = true;
        extraConfig = "proxy_buffering off;";
      };
    };
  };

  containers.degoog = mkContainer {
    # 5 = nextcloud, 6 = jellyfin; 7 keeps the per-host veth subnets unique.
    index = 7;
    specialArgs = { inherit inputs; };
    config =
      { ... }:
      {
        imports = [ inputs.degoog.nixosModules.default ];

        services.degoog = {
          enable = true;
          # Tailnet-only, so the settings gate is disabled rather than
          # protected; anyone on the tailnet may install extensions.
          environment = {
            DEGOOG_PUBLIC_INSTANCE = false;
            DEGOOG_DANGEROUSLY_NO_PASSWORD = true;
            DEGOOG_WIZARD = false;
          };
        };
      };
  };
}
