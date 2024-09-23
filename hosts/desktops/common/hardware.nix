{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  hardware = {
    xpadneo.enable = true;
    bluetooth.enable = true;
    pulseaudio.enable = false;
    steam-hardware.enable = true; # Allow steam client to manage controllers
    graphics.enable32Bit = true; # For OpenGL games
    i2c.enable = true;
  };

  security.rtkit.enable = true; # Needed for pipewire to acquire realtime priority
}
