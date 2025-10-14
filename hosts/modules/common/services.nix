{ ... }:

{
  services = {
    dbus.implementation = "broker";
    irqbalance.enable = true;
    fstrim.enable = true;
  };
}
