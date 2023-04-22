{ inputs, config, pkgs, lib, ... }:

{
  hardware = {
    xpadneo.enable = true;
    bluetooth.enable = true;
    pulseaudio.enable = false; # Use pipewire instead
    steam-hardware.enable = true; # Allow steam client to manage controllers
    opengl.driSupport32Bit = true; # For OpenGL games
  };

  sound.enable = true;

  security.rtkit.enable =
    true; # Needed for pipewire to acquire realtime priority
}
