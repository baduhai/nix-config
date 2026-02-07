{ ... }:

{
  flake.modules.nixos.programs-office =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        aspell
        aspellDicts.de
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.pt_BR
        papers
        presenterm
        rnote
      ];

      services.flatpak.packages = [
        "com.collabora.Office"
      ];
    };
}
