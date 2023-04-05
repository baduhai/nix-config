{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  hardware = {
    xpadneo.enable = true;
    bluetooth.enable = true;
    pulseaudio.enable = false; # Use pipewire instead
    steam-hardware.enable = true; # Allow steam client to manage controllers
    opengl = {
      driSupport32Bit = true; # For OpenGL games
      mesaPackage = pkgs.mesa_22; # NixOS/nixpkgs/issues/223729
    };
  };

  sound.enable = true;

  security.rtkit.enable =
    true; # Needed for pipewire to acquire realtime priority
}
