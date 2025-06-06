{ pkgs, ... }:

{
  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    name = "Breeze_Light";
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-decoration-layout = "appmenu:";
    };
    gtk4.extraConfig = {
      gtk-decoration-layout = "appmenu:";
    };
  };
}
