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
      terminal = "tmux-256color";
      mouse = true;
      keyMode = "vi";
      extraConfig = ''
        set-option -ga terminal-overrides ",alacritty:Tc"
      '';
    };

    zellij = {
      enable = true;
      enableBashIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        format = ''
          [░▒▓](main)$os[](fg:main bg:cyan)$directory[](fg:cyan bg:blue)$git_branch$git_status[](fg:blue bg:purple)$nix_shell$rust[](fg:purple bg:yellow)$time[](fg:yellow)$fill[](fg:yellow)$cmd_duration[](fg:purple bg:yellow)[](fg:blue bg:purple)[](fg:cyan bg:blue)$hostname[▓▒░](main)
          [  ](blue)'';
        palette = "stylix";
        os = {
          disabled = false;
          style = "bg:main fg:background";
          symbols.NixOS = "  ";
        };
        directory = {
          format = "[ $path ]($style)";
          style = "fg:background bg:cyan";
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
          format = "[[ $symbol $branch ](fg:background bg:blue)]($style)";
          style = "bg:blue";
          symbol = "";
        };
        git_status = {
          format =
            "[[($all_status$ahead_behind )](fg:background bg:blue)]($style)";
          style = "bg:blue";
        };
        right_format = "$character";
        nix_shell = {
          format = "[[ $symbol ](fg:background bg:purple)]($style)";
          heuristic = true;
          style = "bg:purple";
          symbol = "󱄅";
        };
        rust = {
          format = "[[ $symbol ($version) ](fg:background bg:purple)]($style)";
          style = "bg:purple";
          symbol = "";
        };
        time = {
          disabled = false;
          format = "[[  $time ](fg:background bg:yellow)]($style)";
          style = "bg:yellow";
          time_format = "%R";
        };
        fill.symbol = " ";
        cmd_duration = {
          format = "[[ $duration  ](fg:background bg:yellow)]($style)";
          min_time = 0;
          style = "bg:yellow";
        };
        hostname = {
          format =
            "[[$ssh_symbol](fg:background bg:cyan)[](bg:cyan fg:main)$hostname ]($style)";
          ssh_only = false;
          ssh_symbol = "  ";
          style = "fg:background bg:main";
        };
        character = {
          error_symbol = "[✗](bold red)";
          success_symbol = "[󱐋](bold green)";
        };
        palettes.stylix = {
          background = config.lib.stylix.colors.withHashtag.base00;
          green = config.lib.stylix.colors.withHashtag.base0B;
          cyan = config.lib.stylix.colors.withHashtag.base0C;
          yellow = config.lib.stylix.colors.withHashtag.base0A;
          red = config.lib.stylix.colors.withHashtag.base08;
          blue = config.lib.stylix.colors.withHashtag.base0D;
          purple = config.lib.stylix.colors.withHashtag.base0E;
          main = config.lib.stylix.colors.withHashtag.base05;
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
