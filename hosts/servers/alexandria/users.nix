{ config, pkgs, ... }:

{
  users.users = {
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL foxtrot@rotterdam" ];
      hashedPassword = "";
    };
    root.hashedPassword = "!";
  };
  
  home-manager.users.user = { pkgs, ... }: {
    home = {
      sessionVariables = {
        EDITOR = "micro";
      };
      file = {
        ".scripts/pfetch" = {
          executable = true;
          source = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/baduhai/dotfiles/master/scripts/pfetch";
            sha256 = "UEfTG1XCuN2GlpPz1gdQ5mxgutlX2XL58rGOqtaUgV4=";
          };
        };
      };
    };
    programs = {
      home-manager.enable = true;
      password-store.enable = true;
      bash = {
        enable = true;
        historyFile = "~/.cache/bash_history";
      };
      #micro = {
      #  enable = true;
      #  settings = {
      #    clipboard = "terminal";
      #    mkparents = true;
      #    scrollbar = true;
      #    tabstospaces = true;
      #    tabsize = 2;
      #  };
      #};
      fish = {
        enable = true;
        interactiveShellInit = "any-nix-shell fish --info-right | source";
        loginShellInit = "any-nix-shell fish --info-right | source";
        shellAliases = {
          d = "kitty +kitten diff";
          nano = "micro";
          wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\"";
        };
        functions = {
          fish_greeting = ''
            set -x PF_INFO ascii title os kernel uptime pkgs memory palette
            eval $HOME/.scripts/pfetch
          '';
          tsh = "ssh -o RequestTTY=yes $argv tmux -u -CC new -A -s tmux-main";
          pacin = "nix-env -iA nixos.$argv";
          pacre = "nix-env -e $argv";
          trizen = "nix-env -qaP $argv";
          rebuild = "sudo nixos-rebuild switch";
          upgrade = "sudo nixos-rebuild switch --upgrade";
        };
        shellInit = ''
          set -g PF_INFO ascii title os kernel uptime wm memory palette
          set -g theme_date_format "+%H:%M"
          set -g theme_date_timezone Europe/Berlin
          set -g theme_avoid_ambiguous_glyphs yes
          set -g theme_color_scheme dark
          set -g theme_nerd_fonts yes
          set -g theme_display_git_default_branch yes
          set -g -x FONTCONFIG_FILE ${pkgs.fontconfig.out}/etc/fonts/fonts.conf
        '';
        plugins  = [
          {
            name = "bobthefish";
            src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "theme-bobthefish";
              rev = "2dcfcab653ae69ae95ab57217fe64c97ae05d8de";
              sha256 = "jBbm0wTNZ7jSoGFxRkTz96QHpc5ViAw9RGsRBkCQEIU=";
            };
          }
          {
            name = "bang-bang";
            src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "plugin-bang-bang";
              rev = "f969c618301163273d0a03d002614d9a81952c1e";
              sha256 = "A8ydBX4LORk+nutjHurqNNWFmW6LIiBPQcxS3x4nbeQ=";
            };
          }
          {
            name = "fzf.fish";
            src = pkgs.fetchFromGitHub {
              owner = "PatrickF1";
              repo = "fzf.fish";
              rev = "v9.2";
              sha256 = "XmRGe39O3xXmTvfawwT2mCwLIyXOlQm7f40mH5tzz+s=";
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
  };
}
