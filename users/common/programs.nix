{ pkgs, ... }:

{
  programs = {
    password-store.enable = true;

    bash = {
      enable = true;
      historyFile = "~/.cache/bash_history";
    };

    helix = {
      enable = true;
      settings = {
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
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "nixfmt";
          }
        ];
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      terminal = "xterm-256color";
      mouse = true;
      keyMode = "vi";
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        format = "$character";
        character = {
          error_symbol = "[ 󱐋](red)";
          success_symbol = "[ 󱐋](green)";
        };
        right_format = "$cmd_duration$git_branch$git_status$nix_shell";
        cmd_duration = {
          format = "[󰄉 $duration ]($style)";
          style = "yellow";
          min_time = 500;
        };
        git_branch = {
          symbol = " ";
          style = "purple";
        };
        git_status.style = "red";
        nix_shell = {
          format = "via [$symbol$state]($style)";
          heuristic = true;
          style = "blue";
          symbol = "󱄅 ";
        };
      };
    };

    git = {
      enable = true;
      diff-so-fancy.enable = true;
      userName = "William";
      userEmail = "baduhai@proton.me";
    };

    btop = {
      enable = true;
      settings = {
        theme_background = false;
        proc_sorting = "cpu direct";
        update_ms = 500;
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = "nix-your-shell fish | source";
      loginShellInit = "nix-your-shell fish | source";
      functions = {
        fish_greeting = "";
        tsh = "ssh -o RequestTTY=yes $argv tmux -u -CC new -A -s tmux-main";
      };
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
