{
  lib,
  fetchurl,
  makeDesktopItem,
  appimageTools,
}:
let
  releaseNotesVersion = "5.1.6";
in
appimageTools.wrapType2 rec {
  pname = "creality-print";
  version = "5.1.6";

  src = fetchurl {
    url = "https://github.com/CrealityOfficial/CrealityPrint/releases/download/v5.1.6/Creality_Print-v5.1.6.10470-x86_64-Release.AppImage";
    hash = "sha256-gS7b41UEvjwUWjCAWjJbD5Xz8QblZkT6tv5ceRhjYfI=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "creality-print";
      exec = "creality-print";
      terminal = false;
      desktopName = "Creality Print";
      comment = meta.description;
      categories = [ "Graphics" ];
    })
  ];

  meta = with lib; {
    description = "Creality 3D Printing Slicing Software";
    homepage = "https://www.creality.com";
    changelog = "https://github.com/CrealityOfficial/CrealityPrint/releases/tag/v${releaseNotesVersion}";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    mainProgram = "creality-print";
  };
}
