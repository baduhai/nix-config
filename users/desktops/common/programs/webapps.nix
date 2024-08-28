{ lib, pkgs, ... }:
let
  mkWebApp = webAppName: webAppLink: webAppIconLink: webAppIconHash:
    let name = lib.strings.replaceStrings [ " " ] [ "" ] webAppName;
    in pkgs.makeDesktopItem {
      inherit name;
      icon = pkgs.fetchurl {
        url = webAppIconLink;
        sha256 = webAppIconHash;
      };
      desktopName = webAppName;
      categories = [ "Network" ];
      startupNotify = true;
      startupWMClass = "chrome-${
          lib.strings.replaceStrings [ "https://" "/" ] [ "" "" ] webAppLink
        }__-Default";
      exec =
        "${pkgs.ungoogled-chromium}/bin/chromium --no-first-run --no-default-browser-check --no-crash-upload --app=${webAppLink} --class=${name}";
    };
in {
  home.packages = [
    (mkWebApp "YT Music" "https://music.youtube.com"
      "https://raw.githubusercontent.com/vinceliuice/Qogir-icon-theme/fff0c7f3747b9b9ddf94c6f997847d47896097c2/src/scalable/apps/youtube-music.svg"
      "sha256-T+v2JOOW+nEwH/9W2PFOrw/315/bCoKHw01KNh2U8IE=")
  ];
}
