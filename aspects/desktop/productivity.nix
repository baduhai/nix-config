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
          leaf-markdown-viewer
          gimp
          inkscape
          obs-studio
          presenterm
          rnote
        ];

        # PhotoCraft, VectorCraft, SoundCraft and SolidCraft ship a CLI (and an
        # MCP server mode) inside the flatpak, next to the GUI, and `flatpak run
        # --command=...` is the only way to reach it. Short names keep that
        # usable. `--cwd` is needed because the sandbox otherwise starts in
        # $HOME and relative paths miss. SolidCraft's `solvecraft-cli` is just a
        # symlink to `solidcraft-cli`, so it needs no alias of its own.
        shellAliases = {
          "photocraft-cli" = "flatpak run --cwd=\"$PWD\" --command=photocraft-cli ai.storyteller.photocraft";
          "soundcraft-cli" = "flatpak run --cwd=\"$PWD\" --command=soundcraft-cli ai.storyteller.soundcraft";
          "filmcraft-cli" = "flatpak run --cwd=\"$PWD\" --command=filmcraft-cli ai.storyteller.filmcraft";
          "vectorcraft-cli" =
            "flatpak run --cwd=\"$PWD\" --command=vectorcraft-cli ai.storyteller.vectorcraft";
          "solidcraft-cli" =
            "flatpak run --cwd=\"$PWD\" --command=solidcraft-cli io.github.bherbruck.SolidCraft";
        };
      };

      services.flatpak = {
        packages = [
          "org.eurooffice.desktopeditors"
          "com.boxy_svg.BoxySVG"
          "io.github.softfever.OrcaSlicer"
          {
            appId = "ai.storyteller.photocraft";
            origin = "flatpark";
          }
          {
            appId = "ai.storyteller.soundcraft";
            origin = "flatpark";
          }
          {
            appId = "ai.storyteller.filmcraft";
            origin = "flatpark";
          }
          {
            appId = "ai.storyteller.vectorcraft";
            origin = "flatpark";
          }
          {
            appId = "io.github.bherbruck.SolidCraft";
            origin = "flatpark";
          }
        ];

        # The sandboxes only expose ~/Documents and ~/Pictures by default. The
        # CLIs take arbitrary paths (MCP read/write roots included), so open them.
        overrides = {
          "ai.storyteller.photocraft".Context.filesystems = [ "host" ];
          "ai.storyteller.vectorcraft".Context.filesystems = [ "host" ];
          "ai.storyteller.soundcraft".Context.filesystems = [ "host" ];
          "io.github.bherbruck.SolidCraft".Context.filesystems = [ "host" ];
        };
      };
    };
}
