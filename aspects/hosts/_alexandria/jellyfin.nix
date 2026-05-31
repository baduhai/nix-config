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
    cat > /var/lib/jellyfin/config/branding.xml << 'BRANDEOF'
<?xml version="1.0" encoding="utf-8"?>
<BrandingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <LoginDisclaimer>&lt;form action=&quot;https://jellyfin.baduhai.dev/sso/OID/start/PocketID&quot;&gt;
  &lt;button class=&quot;raised block emby-button button-submit&quot;&gt;
    Sign in with PocketID
  &lt;/button&gt;
&lt;/form&gt;</LoginDisclaimer>
  <CustomCss>a.raised.emby-button {
  padding: 0.9em 1em;
  color: inherit !important;
}
.disclaimerContainer {
  display: block;
}
#loginPage .manualLoginForm {
  display: none;
}
</CustomCss>
  <SplashscreenEnabled>true</SplashscreenEnabled>
</BrandingOptions>
BRANDEOF
    chown jellyfin:jellyfin /var/lib/jellyfin/config/branding.xml
  '';

  age.secrets.jellyfin-sso = {
    file = "${inputs.self}/secrets/jellyfin-sso.xml.age";
    owner = "jellyfin";
    group = "jellyfin";
  };
}
