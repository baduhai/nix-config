{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  services.matrix-conduit = {
    enable = true;
    extraEnvironment = {
      RUST_MIN_STACK = "16777216";
    };
    package = pkgs.unstable.matrix-conduit;
    settings.global = {
      server_name = "baduhai.me";
      address = "127.0.0.1";
      port = 6167;
      max_request_size = 20000000;
      allow_registration = true;
      allow_encryption = false;
      allow_federation = false;
    };
  };

  services.nginx.virtualHosts."matrix.baduhai.me" = {
    useACMEHost = "baduhai.me";
    forceSSL = true;
    kTLS = true;
    locations."/_matrix/".proxyPass = "http://127.0.0.1:6167$request_uri";
    locations."= /.well-known/matrix/client" = {
      alias = pkgs.writeText "matrix-wk-client" ''
        { "m.homeserver": { "base_url": "https://matrix.baduhai.me" } }
      '';
      extraConfig = "add_header Access-Control-Allow-Origin *;";
    };
    locations."= /.well-known/matrix/server" = {
      alias = pkgs.writeText "matrix-wk-server" ''
        { "m.server": "matrix.baduhai.me:443" }
      '';
      extraConfig = "add_header Access-Control-Allow-Origin *;";
    };
  };
}
