{ inputs, config, pkgs, lib, ... }:

{
  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    keyd = {
      enable = true;
      keyboards.all = {
        ids = [ "*" ];
        settings.main.capslock = "overload(meta, esc)";
      };
    };
  };
}
