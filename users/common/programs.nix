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
        theme = "catppuccin-mocha_transparent";
        editor = {
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
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "nixfmt";
          }
        ];
      };
      themes.catppuccin-mocha_transparent = {
        inherits = "catppuccin_mocha";
        "ui.background" = "{}";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = "set -g mouse on";
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        format = ''
          [░▒▓](text)$os[](fg:text bg:prim)$directory[](fg:prim bg:seco)$git_branch$git_status[](fg:seco bg:tert)$nix_shell$rust[](fg:tert bg:quar)$time[](fg:quar)$fill[](fg:quar)$cmd_duration[](fg:tert bg:quar)[](fg:seco bg:tert)[](fg:prim bg:seco)$hostname[▓▒░](text)
          [  ](seco)'';
        palette = "night";
        os = {
          disabled = false;
          style = "bg:text fg:bg";
          symbols.NixOS = "  ";
        };
        directory = {
          format = "[ $path ]($style)";
          style = "fg:bg bg:prim";
          truncation_length = 3;
          truncation_symbol = "󰇘 ";
          substitutions = {
            Documents = " ";
            Downloads = " ";
            Music = " ";
            Pictures = " ";
            Videos = " ";
          };
        };
        git_branch = {
          format = "[[ $symbol $branch ](fg:bg bg:seco)]($style)";
          style = "bg:seco";
          symbol = "";
        };
        git_status = {
          format = "[[($all_status$ahead_behind )](fg:bg bg:seco)]($style)";
          style = "bg:seco";
        };
        right_format = "$character";
        nix_shell = {
          format = "[[ $symbol ](fg:bg bg:tert)]($style)";
          heuristic = true;
          style = "bg:tert";
          symbol = "󱄅";
        };
        rust = {
          format = "[[ $symbol ($version) ](fg:bg bg:tert)]($style)";
          style = "bg:tert";
          symbol = "";
        };
        time = {
          disabled = false;
          format = "[[  $time ](fg:seco bg:quar)]($style)";
          style = "bg:quar";
          time_format = "%R";
        };
        fill.symbol = " ";
        cmd_duration = {
          format = "[[ $duration  ](fg:seco bg:quar)]($style)";
          min_time = 0;
          style = "bg:quar";
        };
        hostname = {
          format =
            "[[$ssh_symbol](fg:bg bg:prim)[](bg:prim fg:text)$hostname ]($style)";
          ssh_only = false;
          ssh_symbol = "  ";
          style = "fg:bg bg:text";
        };
        character = {
          error_symbol = "[✗](bold red) ";
          success_symbol = "[󱐋](bold green) ";
        };
        palettes.night = {
          bg = "#1E1E2E";
          green = "#a6e3a1";
          prim = "#a2b3e6";
          quar = "#303062";
          red = "#f38ba8";
          seco = "#738cd9";
          tert = "#4566cd";
          text = "#d0d9f2";
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
        color_theme = "catppuccin_mocha.theme";
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
        set -g -x NNN_OPTS H
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
