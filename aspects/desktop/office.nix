{ ... }:

{
  flake.modules.nixos.office =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        aspell
        aspellDicts.de
        aspellDicts.en
        aspellDicts.pt_BR
        glow
        kwrite
        presenterm
        rnote
      ];

      services.flatpak.packages = [
        "com.collabora.Office"
      ];
    };
}
