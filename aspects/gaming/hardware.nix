{ ... }:

{
  flake.modules.nixos.gaming-hardware =
    { ... }:
    {
      hardware = {
        xpadneo.enable = true;
        steam-hardware.enable = true; # Allow steam client to manage controllers
        graphics.enable32Bit = true; # For OpenGL games
      };
    };
}
