{ config
, pkgs
, inputs
, ...
}:

let
  # You'll need to edit these values

  # The hostname that will appear in your user and room IDs
  server_name = "baduhai.me";

  # The hostname that Conduit actually runs on
  #
  # This can be the same as `server_name` if you want. This is only necessary
  # when Conduit is running on a different machine than the one hosting your
  # root domain. This configuration also assumes this is all running on a single
  # machine, some tweaks will need to be made if this is not the case.
  matrix_hostname = "matrix.${server_name}";

  # An admin email for TLS certificate notifications
  admin_email = "admin@${server_name}";

  # These ones you can leave alone

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/server`
  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "${matrix_hostname}"
    }
  '';

  # Build a dervation that stores the content of `${server_name}/.well-known/matrix/client`
  well_known_client = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://${matrix_hostname}"
      }
    }
  '';
in
  
{
  # Configure Conduit itself
  services.matrix-conduit = {
    enable = true;

    package = pkgs.unstable.matrix-conduit;


    settings.global = {
      allow_federation = false;
      allow_registration = true;
      inherit server_name;
    };
  };

  # Configure NGINX as a reverse proxy
  services.nginx = {

    virtualHosts = {
      "${matrix_hostname}" = {
        useACMEHost = "baduhai.me";
        forceSSL = true;
        kTLS = true;

        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 8448;
            ssl = true;
          }
        ];

        locations."/_matrix/" = {
          proxyPass = "http://backend_conduit$request_uri";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_buffering off;
          '';
        };

        extraConfig = ''
          merge_slashes off;
        '';
      };

      "${server_name}" = {
        locations."=/.well-known/matrix/server" = {
          # Use the contents of the derivation built previously
          alias = "${well_known_server}";

          extraConfig = ''
            # Set the header since by default NGINX thinks it's just bytes
            default_type application/json;
          '';
        };

        locations."=/.well-known/matrix/client" = {
          # Use the contents of the derivation built previously
          alias = "${well_known_client}";

          extraConfig = ''
            # Set the header since by default NGINX thinks it's just bytes
            default_type application/json;
          
            # https://matrix.org/docs/spec/client_server/r0.4.0#web-browser-clients
            add_header Access-Control-Allow-Origin "*";
          '';
        };
      };
    };

    upstreams = {
      "backend_conduit" = {
        servers = {
          "localhost:${toString config.services.matrix-conduit.settings.global.port}" = { };
        };
      };
    };
  };

  # Open firewall ports for Matrix federation
  networking.firewall.allowedTCPPorts = [ 8448 ];
  networking.firewall.allowedUDPPorts = [ 8448 ];
}
          
