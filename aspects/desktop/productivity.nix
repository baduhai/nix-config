# Office documents, note-taking, presentations and the creative
# apps every desktop should have: editors (gimp, inkscape, ...)
# and their flatpak counterparts.
{ ... }:

{
  flake.modules.nixos.productivity =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        aspell
        aspellDicts.de
        aspellDicts.en
        aspellDicts.pt_BR
        glow
        gimp
        inkscape
        obs-studio
        presenterm
        rnote
      ];

      services.flatpak.packages = [
        "com.collabora.Office"
        "com.boxy_svg.BoxySVG"
        "io.github.softfever.OrcaSlicer"
        # Not on Flathub; only published by the FlatPark repo.
        {
          appId = "ai.storyteller.photocraft";
          origin = "flatpark";
        }
        {
          appId = "ai.storyteller.vectorcraft";
          origin = "flatpark";
        }
      ];
    };
}
