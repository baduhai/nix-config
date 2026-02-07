{ ... }:
{
  flake.modules.homeManager.cli-helix = { config, lib, pkgs, ... }: {
    home.sessionVariables = {
      EDITOR = "hx";
    };

    programs.helix = {
      enable = true;
      settings = {
        editor = {
          file-picker.hidden = false;
          idle-timeout = 0;
          line-number = "relative";
          cursor-shape = {
            normal = "underline";
            insert = "bar";
            select = "underline";
          };
          soft-wrap.enable = true;
          auto-format = true;
          indent-guides.render = true;
        };
        keys.normal = {
          space = {
            o = "file_picker_in_current_buffer_directory";
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
          };
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "nixfmt";
          }
          {
            name = "typst";
            auto-format = true;
            formatter.command = "typstyle -c 1000 -i";
          }
        ];
      };
    };
  };
}
