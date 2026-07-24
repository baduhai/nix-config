{ ... }:

{
  flake.modules.nixos.sunshine =
    { ... }:
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      users.users.user.extraGroups = [ "uinput" ];
    };
}
