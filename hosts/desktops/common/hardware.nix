{ config, pkgs, lib, ... }:

{
  hardware = {
    bluetooth.enable = true;
    opengl.driSupport32Bit = true; # For OpenGL games
    steam-hardware.enable = true; # Allow steam client to manage controllers
    pulseaudio.enable = false; # Use pipewire instead
  };

  sound.enable = true;

  security.rtkit.enable = true; # Needed for pipewire to acquire realtime priority
}
