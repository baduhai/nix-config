{ ... }:

{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://pass.baduhai.dev";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "/run/vaultwarden/vaultwarden.sock";
    };
  };
}
