{ ... }:

{
  flake.modules.nixos.gaming-launchers =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        clonehero
        heroic
        prismlauncher
      ];
    };
}
