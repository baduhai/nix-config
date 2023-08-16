{ inputs, config, pkgs, lib, ... }:

{
  services.emacs = {
    enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
    client.enable = true;
  };
}
