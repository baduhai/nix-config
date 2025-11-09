{
  config,
  inputs,
  pkgs,
  ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ xwayland-satellite ];

  programs = {

    ghostty = {
      enable = true;
      settings = {
        cursor-style = "block";
        shell-integration-features = "no-cursor";
        cursor-style-blink = false;
        custom-shader = "${builtins.fetchurl {
          url = "https://raw.githubusercontent.com/hackr-sh/ghostty-shaders/cb6eb4b0d1a3101c869c62e458b25a826f9dcde3/cursor_blaze.glsl";
          sha256 = "sha256:0g2lgqjdrn3c51glry7x2z30y7ml0y61arl5ykmf4yj0p85s5f41";
        }}";
        bell-features = "";
        gtk-titlebar-style = "tabs";
        keybind = [ "shift+enter=text:\\x1b\\r" ];
      };
    };

    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [
          "re.sonny.Junction.desktop"
          "zen-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/http" = [
          "re.sonny.Junction.desktop"
          "zen-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/https" = [
          "re.sonny.Junction.desktop"
          "zen-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/about" = [
          "re.sonny.Junction.desktop"
          "zen-browser.desktop"
          "torbrowser.desktop"
        ];
        "x-scheme-handler/unknown" = [
          "re.sonny.Junction.desktop"
          "zen-browser.desktop"
          "torbrowser.desktop"
        ];
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "video/mp4" = "io.bassi.Showtime.desktop";
        "video/x-matroska" = "io.bassi.Showtime.desktop";
        "video/webm" = "io.bassi.Showtime.desktop";
        "video/mpeg" = "io.bassi.Showtime.desktop";
        "video/x-msvideo" = "io.bassi.Showtime.desktop";
        "video/quicktime" = "io.bassi.Showtime.desktop";
        "video/x-flv" = "io.bassi.Showtime.desktop";
        "audio/mpeg" = "io.bassi.Showtime.desktop";
        "audio/flac" = "io.bassi.Showtime.desktop";
        "audio/ogg" = "io.bassi.Showtime.desktop";
        "audio/wav" = "io.bassi.Showtime.desktop";
        "audio/mp4" = "io.bassi.Showtime.desktop";
        "audio/x-opus+ogg" = "io.bassi.Showtime.desktop";
        "application/pdf" = [
          "org.gnome.Papers.desktop"
          "zen-browser.desktop"
        ];
        "text/plain" = "Helix.desktop";
        "text/markdown" = "Helix.desktop";
        "text/x-log" = "Helix.desktop";
        "application/x-shellscript" = "Helix.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
          "onlyoffice-desktopeditors.desktop"; # DOCX
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
          "onlyoffice-desktopeditors.desktop"; # XLSX
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" =
          "onlyoffice-desktopeditors.desktop"; # PPTX
        "application/vnd.oasis.opendocument.text" = "onlyoffice-desktopeditors.desktop"; # ODT
        "application/vnd.oasis.opendocument.spreadsheet" = "onlyoffice-desktopeditors.desktop"; # ODS
        "application/vnd.oasis.opendocument.presentation" = "onlyoffice-desktopeditors.desktop"; # ODP
        "application/msword" = "onlyoffice-desktopeditors.desktop"; # DOC
        "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop"; # XLS
        "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop"; # PPT
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
        "application/x-bzip" = "org.gnome.FileRoller.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  };

  # Set Ghostty as default terminal
  home.sessionVariables = {
    TERMINAL = "ghostty";
  };
}
