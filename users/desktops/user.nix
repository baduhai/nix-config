{ ... }:

{
  imports = [
    # Host-common imports
    ../common
    # Desktop-common imports
    ./common
  ];

  stylix.targets.gtk.flatpakSupport.enable = false;
}
