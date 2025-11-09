{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  utils = import ../../utils.nix { inherit inputs lib; };
  inherit (utils) mkNginxVHosts;
  kanidmCertDir = "/var/lib/kanidm/certs";
in

{
  services.kanidm = {
    enableServer = true;
    enableClient = true;
    package = pkgs.kanidm;

    serverSettings = {
      domain = "auth.baduhai.dev";
      origin = "https://auth.baduhai.dev";
      bindaddress = "127.0.0.1:8443";
      ldapbindaddress = "127.0.0.1:636";
      trust_x_forward_for = true;
      # Use self-signed certificates for internal TLS
      tls_chain = "${kanidmCertDir}/cert.pem";
      tls_key = "${kanidmCertDir}/key.pem";
    };

    clientSettings = {
      uri = "https://auth.baduhai.dev";
    };
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."auth.baduhai.dev" = {
      locations."/" = {
        proxyPass = "https://127.0.0.1:8443";
        extraConfig = ''
          proxy_ssl_verify off;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $host;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 636 ];

  # Generate self-signed certificates for kanidm's internal TLS
  systemd.services.kanidm-generate-certs = {
    description = "Generate self-signed TLS certificates for Kanidm";
    wantedBy = [ "multi-user.target" ];
    before = [ "kanidm.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p ${kanidmCertDir}
      if [ ! -f ${kanidmCertDir}/key.pem ]; then
        ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:4096 \
          -keyout ${kanidmCertDir}/key.pem \
          -out ${kanidmCertDir}/cert.pem \
          -days 3650 -nodes \
          -subj "/CN=localhost" \
          -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
        chown -R kanidm:kanidm ${kanidmCertDir}
        chmod 600 ${kanidmCertDir}/key.pem
        chmod 644 ${kanidmCertDir}/cert.pem
      fi
    '';
  };

  # Ensure certificate generation runs before kanidm starts
  systemd.services.kanidm = {
    after = [ "kanidm-generate-certs.service" ];
    wants = [ "kanidm-generate-certs.service" ];
  };
}
