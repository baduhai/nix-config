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
        packages = with pkgs; [ nix-your-shell ];
      };

      programs = {
        helix.languages = {
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

        password-store.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        fish = {
          interactiveShellInit = "nix-your-shell fish | source";
          loginShellInit = "nix-your-shell fish | source";
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
            format = ''
              $directory$git_branch$git_status$nix_shell
              [ ❯ ](bold green)
            '';
            right_format = "$cmd_duration$character";
            character = {
              error_symbol = "[](red)";
              success_symbol = "[󱐋](green)";
            };
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
      };
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {

    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      fonts.fontconfig.enable = true;

      programs = {
        password-store.package = pkgs.pass-wayland;

        mangohud.enable = true;

        obs-studio = {
          enable = true;
          plugins = [
            pkgs.obs-studio-plugins.obs-vkcapture
            pkgs.obs-studio-plugins.obs-backgroundremoval
            pkgs.obs-studio-plugins.obs-pipewire-audio-capture
          ];
        };

        fish = {
          functions = {
            sysrebuild = "nh os switch --ask";
            sysrebuild-boot = "nh os boot --ask";
            sysupdate = "nix flake update --commit-lock-file --flake /home/user/Projects/personal/nix-config";
          };
        };
      };
    })
  ];
}
