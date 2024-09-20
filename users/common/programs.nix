{ config, pkgs, lib, ... }:

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
          mouse = false;
          soft-wrap.enable = true;
          auto-format = true;
          indent-guides.render = true;
        };
        keys.normal.space = {
          space = "file_picker";
          w = ":w";
          q = ":q";
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
      };
      languages = {
        language = [{
          name = "nix";
          auto-format = true;
          formatter.command = "nixfmt";
        }];
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
        format = "$git_branch$git_status$nix_shell[ ](bold green)";
        git_branch.symbol = " ";
        nix_shell = {
          format = "via [$symbol $state]($style) ";
          heuristic = true;
          symbol = "󱄅";
        };
        right_format = "$cmd_duration$character";
        cmd_duration = {
          format = "[ $duration ]($style)";
          style = "yellow";
          min_time = 10;
        };
        character = {
          error_symbol = "[✗](bold red)";
          success_symbol = "[󱐋](bold green)";
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
      shellAliases = {
        wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
        h = "hx";
      };
      functions = {
        fish_greeting = "";
        tsh = "ssh -o RequestTTY=yes $argv tmux -u -CC new -A -s tmux-main";
      };
      shellInit = ''
        set -g -x FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf
      '';
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
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "v9.2";
            sha256 = "sha256-XmRGe39O3xXmTvfawwT2mCwLIyXOlQm7f40mH5tzz+s=";
          };
        }
      ];
    };
  };
}
