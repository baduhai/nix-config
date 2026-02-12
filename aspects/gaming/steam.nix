{ ... }:

{
  flake.modules.nixos.gaming-steam =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        steam-run
      ];

      programs = {
        steam = {
          enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
        gamemode.enable = true;
      };
    };
}
