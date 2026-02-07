{ ... }:
{
  flake.modules.nixos.common-services = { ... }: {
    services = {
      dbus.implementation = "broker";
      irqbalance.enable = true;
      fstrim.enable = true;
    };
  };
}
