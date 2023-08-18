{ inputs, config, pkgs, lib, ... }: {
  programs = {
    password-store.enable = true;
    bash = {
      enable = true;
      historyFile = "~/.cache/bash_history";
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin-mocha_transparent";
        editor = {
          line-number = "relative";
          cursor-shape.insert = "bar";
          mouse = false;
        };
        keys.normal.space = {
          space = "file_picker";
          w = ":w";
          q = ":q";
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
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
    micro = {
      enable = true;
      settings = {
        clipboard = "terminal";
        mkparents = true;
        scrollbar = true;
        tabstospaces = true;
        tabsize = 2;
        colorscheme = "simple";
      };
    };
    fish = {
      enable = true;
      interactiveShellInit = "nix-your-shell fish | source";
      loginShellInit = "nix-your-shell fish | source";
      shellAliases = {
        wget = ''wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'';
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
