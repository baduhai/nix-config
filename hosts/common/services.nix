{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

{
  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    tailscale = {
      enable = true;
      extraUpFlags = [ "--operator=user" ];
    };
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
