{ inputs, config, pkgs, lib, ... }:

{
  services = {
    matrix-conduit = {
      enable = true;
      extraEnvironment = { RUST_MIN_STACK = "16777216"; };
      package = pkgs.unstable.matrix-conduit;
      settings.global = {
        server_name = "baduhai.dev";
        address = "127.0.0.1";
        port = 6167;
        max_request_size = 20000000;
        allow_registration = true;
        allow_encryption = false;
        allow_federation = false;
      };
    };

    nginx.virtualHosts."matrix.baduhai.dev" = {
      useACMEHost = "baduhai.dev";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.cinny2}";
      locations."/_matrix/".proxyPass = "http://127.0.0.1:6167$request_uri";
      locations."= /.well-known/matrix/client" = {
        alias = pkgs.writeText "matrix-wk-client" ''
          { "m.homeserver": { "base_url": "https://matrix.baduhai.dev" } }
        '';
        extraConfig = "add_header Access-Control-Allow-Origin *;";
      };
      locations."= /.well-known/matrix/server" = {
        alias = pkgs.writeText "matrix-wk-server" ''
          { "m.server": "matrix.baduhai.dev:443" }
        '';
        extraConfig = "add_header Access-Control-Allow-Origin *;";
      };
    };
  };

  virtualisation.oci-containers.containers."cinny2" = {
    image = "ghcr.io/cinnyapp/cinny:latest";
    ports = [ "${config.ports.cinny2}:80" ];
    environment = { TZ = "America/Bahia"; };
    volumes = [ "/data/matrix/cinny-config.json:/app/config.json" ];
    extraOptions = [ "--pull=always" ];
  };
}
