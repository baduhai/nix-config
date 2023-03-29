{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        "actual" = {
          image = "jlongster/actual-server:latest";
          ports = [
            "${config.ports.actual}:5006"
          ];
          volumes = [
            "/data/actual:/data"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "cinny" = {
          image = "ghcr.io/cinnyapp/cinny:latest";
          ports = [
            "${config.ports.cinny}:80"
          ];
          volumes = [
            "/data/matrix/cinny-config.json:/app/config.json"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "cinny2" = {
          image = "ghcr.io/cinnyapp/cinny:latest";
          ports = [
            "${config.ports.cinny2}:80"
          ];
          volumes = [
            "/data/matrix/cinny-config.json:/app/config.json"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "librespeed" = {
          image = "lscr.io/linuxserver/librespeed:latest";
          environment = {
            TZ = "America/Bahia";
          };
          ports = [
            "${config.ports.librespeed}:80"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
        "whoogle" = {
          image = "benbusby/whoogle-search:latest";
          environment = {
            HTTPS_ONLY = "1";
            WHOOGLE_CONFIG_LANGUAGE = "lang_en";
            WHOOGLE_CONFIG_THEME = "system";
            WHOOGLE_CONFIG_VIEW_IMAGE = "1";
            WHOOGLE_CONFIG_GET_ONLY = "1";
          };
          ports = [
            "${config.ports.whoogle}:5000"
          ];
          extraOptions = [
            "--pull=always"
          ];
        };
      };
    };
  };
}
