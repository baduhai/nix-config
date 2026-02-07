{ pkgs, ... }:

{
  services = {
    keyd = {
      enable = true;
      keyboards.main = {
        ids = [ "0001:0001" ];
        settings = {
          main = {
            meta = "overload(meta, esc)";
            f1 = "back";
            f2 = "forward";
            f3 = "refresh";
            f4 = "M-f11";
            f5 = "M-w";
            f6 = "brightnessdown";
            f7 = "brightnessup";
            f8 = "timeout(mute, 200, micmute)";
            f9 = "play";
            f10 = "timeout(nextsong, 200, previoussong)";
            f13 = "delete";
            "102nd" = "layer(function)";
          };
          shift = {
            leftshift = "capslock";
            rightshift = "capslock";
          };
          function = {
            escape = "f1";
            f1 = "f2";
            f2 = "f3";
            f3 = "f4";
            f4 = "f5";
            f5 = "f6";
            f6 = "f7";
            f7 = "f8";
            f8 = "f9";
            f9 = "f10";
            f10 = "f11";
            f13 = "f12";
            y = "sysrq";
            k = "home";
            l = "pageup";
            "," = "end";
            "." = "pagedown";
          };
        };
      };
    };
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };

  # TODO: remove once gmodena/nix-flatpak/issues/45 fixed
  systemd.services."flatpak-managed-install" = {
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
    };
  };
}
