{ config, lib, inputs, ... }:
let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.nginx.virtualHosts = mkNginxVHosts {
    domains."jellyfin.baduhai.dev".locations."/".proxyPass = "http://127.0.0.1:8096/";
  };

  systemd.services.jellyfin.preStart = ''
    cp ${config.age.secrets.jellyfin-sso.path} /var/lib/jellyfin/plugins/configurations/SSO-Auth.xml
    chown jellyfin:jellyfin /var/lib/jellyfin/plugins/configurations/SSO-Auth.xml
  '';

  age.secrets.jellyfin-sso = {
    file = "${inputs.self}/secrets/jellyfin-sso.xml.age";
    owner = "jellyfin";
    group = "jellyfin";
  };
}
