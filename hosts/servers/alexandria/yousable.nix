{ inputs, config, pkgs, lib, ... }:

let
  configyaml = pkgs.writeTextFile {
    name = "config.yaml";
    text = ''
      paths:
        meta: /data/yousable/meta
        out: /data/yousable/out
        tmp: /data/yousable/tmp
        live: /data/yousable/live
        x_accel: /out

      secrets: ~
      authorization: ~

      profiles:
        default:
          video: false
          container: opus
          download:
            format: 'ba[vcodec=none]'
            format_sort: [ 'acodec:opus' ]
          live:
            audio:
              format_sort: [ 'acodec:opus' ]

      feed_defaults:
        load_entries: 10                 # query only the last L videos from youtube
        keep_entries: 10                 # keep at least the last K videos on disk
        keep_entries_seconds: 1000000000 # keep videos that are less than M seconds old
        live_slice_seconds: 1200         # fill paths.live with fragments N seconds long
        poll_seconds: 21600              # look for new videos roughly P seconds often
        profiles: [ default ]

      feeds:
        TL:
          url: https://www.youtube.com/channel/UCeeFfhMcJa1kjtfZAGskOCA
          overrides:
            title: TechLinked
        GL:
          url: https://www.youtube.com/channel/UCHDxYLv8iovIbhrfl16CNyg
          overrides:
            title: GameLinked
        JS:
          url: https://www.youtube.com/channel/UC-2YHgc363EdcusLIBbgxzg
          overrides:
            title: Answers with Joe
        HOTU:
          url: https://www.youtube.com/channel/UCtRFmSyL4fSLQkn-wMqlmdA
          overrides:
            title: History of the Universe
        SEA:
          url: https://www.youtube.com/channel/UCG9ShGbASoiwHwFcLcAh9EA
          overrides:
            title: SEA
        TH:
          url: https://www.youtube.com/channel/UCSwFnHpDt-lZgR_7Sqisi6A
          overrides:
            title: The Histocrat
        L1T:
          url: https://www.youtube.com/channel/UC4w1YQAJMWOz4qtxinq55LQ
          overrides:
            title: Level 1 News
        TSR:
          url: https://www.youtube.com/channel/UCeMcDx6-rOq_RlKSPehk2tQ
          overrides:
            title: The Space Race
    '';
  };

in {
  services = {
    yousable = {
      enable = true;
      port = lib.toInt "${config.ports.yousable}";
      configFile = "${configyaml}";
    };

    nginx.virtualHosts."yousable.baduhai.me" = {
      useACMEHost = "baduhai.me";
      forceSSL = true;
      kTLS = true;
      locations."/".proxyPass = "http://127.0.0.1:${config.ports.yousable}";
      extraConfig = ''
        gzip off;
        gzip_proxied off;
        proxy_cache off;
        proxy_buffering off;
      '';
      locations."/out" = {
        root = "/data/yousable";
        extraConfig = ''
          autoindex off;
          internal;
        '';
      };
    };
  };
}
