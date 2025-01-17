{ config, ... }:

{
  virtualisation.oci-containers.containers."memos" = {
    image = "docker.io/neosmemo/memos:stable";
    ports = [ "${config.ports.memos}:5230" ];
    environment = {
      TZ = "America/Bahia";
    };
    volumes = [ "/data/memos/:/var/opt/memos" ];
    extraOptions = [
      "--pull=newer"
      "--label=io.containers.autoupdate=registry"
    ];
  };

  services.nginx.virtualHosts."notes.baduhai.dev" = {
    useACMEHost = "baduhai.dev";
    forceSSL = true;
    kTLS = true;
    locations."/".proxyPass = "http://127.0.0.1:${config.ports.memos}";
  };
}
