{ inputs, ... }:
{
  flake.modules.nixos.desktop-services = { config, lib, pkgs, ... }: {
    # Import parent aspect for inheritance
    imports = [ inputs.self.modules.nixos.common-services ];

    services = {
      printing.enable = true;
      udev.packages = with pkgs; [ yubikey-personalization ];
      keyd = {
        enable = true;
        keyboards.all = {
          ids = [ "*" ];
          settings.main.capslock = "overload(meta, esc)";
        };
      };
    };
  };
}
