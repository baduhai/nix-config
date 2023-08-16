{ inputs, config, pkgs, lib, ... }:

{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs.emacs29-pgtk;
    socketActivation.enable = true;
  };
}
