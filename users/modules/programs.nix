{
  config,
  hostType,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      home = {
        sessionVariables = {
          EDITOR = "hx";
        };
      };

      programs = {
        bash = {
          enable = true;
          historyFile = "~/.cache/bash_history";
        };

        helix = {
          enable = true;
          settings = {
            theme = "catppuccin_mocha";
            editor = {
              file-picker.hidden = false;
              idle-timeout = 0;
              line-number = "relative";
              cursor-shape = {
                normal = "block";
                insert = "bar";
                select = "underline";
              };
              soft-wrap.enable = true;
              auto-format = true;
              indent-guides.render = true;
            };
            keys.normal.space = {
              space = "file_picker";
              w = ":w";
              q = ":q";
              o = "file_picker_in_current_buffer_directory";
              esc = [
                "collapse_selection"
                "keep_primary_selection"
              ];
            };
          };
        };

        fish = {
          enable = true;
          functions.fish_greeting = "";
          plugins = [
            {
              name = "bang-bang";
              src = pkgs.fetchFromGitHub {
                owner = "oh-my-fish";
                repo = "plugin-bang-bang";
                rev = "f969c618301163273d0a03d002614d9a81952c1e";
                sha256 = "sha256-A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
              };
            }
            {
              name = "z";
              src = pkgs.fetchFromGitHub {
                owner = "jethrokuan";
                repo = "z";
                rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
                sha256 = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
              };
            }
            {
              name = "sponge";
              src = pkgs.fetchFromGitHub {
                owner = "meaningful-ooo";
                repo = "sponge";
                rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
                sha256 = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
              };
            }
          ];
        };
      };

    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
    })
  ];
}
