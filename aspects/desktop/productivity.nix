# Office documents, note-taking, presentations and the creative
# apps every desktop should have: editors (gimp, inkscape, ...)
# and their flatpak counterparts.
{ ... }:

{
  flake.modules.nixos.productivity =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
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

        # PhotoCraft and VectorCraft ship a CLI (and an MCP server mode) inside
        # the flatpak, next to the GUI, and `flatpak run --command=...` is the
        # only way to reach it. Short names keep that usable. `--cwd` is needed
        # because the sandbox otherwise starts in $HOME and relative paths miss.
        shellAliases = {
          "photocraft-cli" = "flatpak run --cwd=\"$PWD\" --command=photocraft-cli ai.storyteller.photocraft";
          "vectorcraft-cli" =
            "flatpak run --cwd=\"$PWD\" --command=vectorcraft-cli ai.storyteller.vectorcraft";
          "soundcraft-cli" = "flatpak run --cwd \"$PWD\"--command=soundcraft-cli ai.storyteller.soundcraft";
        };
      };

      services.flatpak = {
        packages = [
          "com.collabora.Office"
          "com.boxy_svg.BoxySVG"
          "io.github.softfever.OrcaSlicer"
          {
            appId = "ai.storyteller.photocraft";
            origin = "flatpark";
          }
          {
            appId = "ai.storyteller.vectorcraft";
            origin = "flatpark";
          }
          {
            appId = "ai.storyteller.soundcraft";
            origin = "flatpark";
          }
        ];

        # Both sandboxes only expose ~/Documents and ~/Pictures by default. The
        # CLIs take arbitrary paths (MCP read/write roots included), so open them.
        overrides = {
          "ai.storyteller.photocraft".Context.filesystems = [ "host" ];
          "ai.storyteller.vectorcraft".Context.filesystems = [ "host" ];
          "ai.storyteller.soundcraft".Context.filesystems = [ "host" ];
        };
      };
    };
}
