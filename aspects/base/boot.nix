{ ... }:
{
  flake.modules.nixos.boot =
    { pkgs, ... }:
    {
      boot = {
        loader = {
          timeout = 3;
          efi.canTouchEfiVariables = true;
          systemd-boot = {
            enable = true;
            editor = false;
            consoleMode = "max";
            sortKey = "aa";
            netbootxyz = {
              enable = true;
              sortKey = "zz";
            };
          };
        };
      };
    };
}
