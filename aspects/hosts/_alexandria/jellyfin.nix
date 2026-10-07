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
    domains."jellyfin.baduhai.dev".locations."/".proxyPass = "http://10.233.6.2:8096/";
  };

  # Keep 8096 reachable directly for native clients (was services.jellyfin.openFirewall).
  # nspawn's own --port forwarding doesn't survive the host nftables firewall,
  # so DNAT via the host's NAT instead.
  networking.firewall.allowedTCPPorts = [ 8096 ];
  networking.nat = {
    externalInterface = "enp1s0";
    forwardPorts = [
      {
        sourcePort = 8096;
        destination = "10.233.6.2:8096";
      }
    ];
  };

  age.secrets.jellyfin-sso = {
    file = "${inputs.self}/secrets/jellyfin-sso.xml.age";
    owner = "jellyfin";
    group = "jellyfin";
  };

  # The host still owns the decrypted secret, so the service user must exist
  # here too (pinned to the container's uid/gid).
  users = {
    users.jellyfin = {
      isSystemUser = true;
      group = "jellyfin";
      uid = 989;
    };
    groups.jellyfin.gid = 977;
  };

  containers.jellyfin =
    (mkContainer {
      index = 6;
      # Media library is far too large to move into the container root.
      bindMounts."/data/media" = {
        hostPath = "/data/media";
        isReadOnly = false;
      };
      config = { ... }: {
        # uid/gid pinned to the host's existing on-disk ownership so the moved
        # data (and /data/media) keeps its owner without a recursive chown.
        users = {
          users.jellyfin.uid = 989;
          groups.jellyfin.gid = 977;
        };

        services.jellyfin.enable = true;

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
        '';
      };
    })
    // {
      # Stable on the hosts, but Jellyfin 12.x only ships on unstable.
      nixpkgs = inputs.nixpkgs.outPath;
    };
}
