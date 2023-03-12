{ specialArgs, inputs, config, pkgs, lib, ... }:

{
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
    micro = {
      enable = true;
      settings = {
        clipboard = "terminal";
        mkparents = true;
        scrollbar = true;
        tabstospaces = true;
        tabsize = 4;
        colorscheme = "simple";
      };
    };
    oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile "${inputs.dotfiles}/omp.json"));
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
      # interactiveShellInit = "nix-your-shell fish | source"; # nix-your-shell only in unstable
      # loginShellInit = "nix-your-shell fish | source";
      shellAliases = {
        nano = "micro";
        wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\"";
      };
      functions = {
        fish_greeting = "";
        tsh = "ssh -o RequestTTY=yes $argv tmux -u -CC new -A -s tmux-main";
      };
      shellInit = ''
        set -g -x NNN_OPTS H
        set -g -x FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf
      '';
      plugins  = [
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
    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = "set -g mouse on";
    };
  };
}
