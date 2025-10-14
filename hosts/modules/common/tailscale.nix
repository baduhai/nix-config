{ ... }:

{
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--operator=user" ];
  };
}
