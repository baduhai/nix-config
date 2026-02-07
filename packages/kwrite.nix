{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.kwrite = pkgs.symlinkJoin {
        name = "kwrite";
        paths = [ pkgs.kdePackages.kate ];
        postBuild = ''
          rm -rf $out/bin/kate \
                 $out/bin/.kate-wrapped \
                 $out/share/applications/org.kde.kate.desktop \
                 $out/share/man \
                 $out/share/icons/hicolor/*/apps/kate.png \
                 $out/share/icons/hicolor/scalable/apps/kate.svg \
                 $out/share/appdata/org.kde.kate.appdata.xml
        '';
      };
    };
}
