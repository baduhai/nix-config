{
  config,
  inputs,
  pkgs,
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
      pluginPackages = with pkgs; [
        tt-rss-theme-feedly
        tt-rss-plugin-af-readability
      ];
    };

    nginx.virtualHosts = mkNginxVHosts {
      domains."rss.baduhai.dev" = {
        root = "${config.services."tt-rss".root}/www";
        locations = {
          "/".index = "index.php";
          "~* /feed-icons/(\\d+)\\.ico".return = "302 /public.php?op=feed_icon&id=$1";
          "~ \\.php$" = {
            extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${config.services."tt-rss".pool}.socket};
              fastcgi_index index.php;
            '';
          };
        };
      };
    };
  };
}
