{
  config,
  inputs,
  ...
}:

let
  mkNginxVHosts = inputs.self.lib.mkNginxVHosts;
in

{
  services = {
    "tt-rss" = {
      enable = true;
      selfUrlPath = "https://rss.baduhai.dev";
      singleUserMode = true;
      virtualHost = null;
      database.createLocally = true;
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev" = {
        root = "${config.services."tt-rss".root}/www";

        locations."/".index = "index.php";

        locations."~* /feed-icons/(\\d+)\\.ico".return = "302 /public.php?op=feed_icon&id=$1";

        locations."~ \\.php$" = {
          extraConfig = ''
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:${config.services.phpfpm.pools.${config.services."tt-rss".pool}.socket};
            fastcgi_index index.php;
          '';
        };
      };
    };
  };
}
