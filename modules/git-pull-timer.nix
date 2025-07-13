{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.git-pull-timer;
in
{
  options.services.git-pull-timer = {
    enable = mkEnableOption "git pull timer service";

    onCalendar = mkOption {
      type = types.listOf types.str;
      default = [ "daily" ];
      description = "OnCalendar options for the timer (systemd calendar format)";
      example = [
        "hourly"
        "daily"
        "*:0/30"
      ];
    };

    onBoot = mkOption {
      type = types.bool;
      default = false;
      description = "Enable OnBootSec = 5min option for the timer";
    };

    persistent = mkOption {
      type = types.bool;
      default = true;
      description = "Persistent option for the timer (catch up missed runs)";
    };

    remoteAddresses = mkOption {
      type = types.listOf types.str;
      default = null;
      description = "List of git remote addresses to try in order";
      example = [
        "git@github.com:user/repo.git"
        "https://github.com/user/repo.git"
      ];
    };

    directory = mkOption {
      type = types.str;
      default = "/etc/nixos";
      description = "Directory where the git repository should be located";
    };

    user = mkOption {
      type = types.str;
      default = null;
      description = "User to run the git operations as";
    };

    group = mkOption {
      type = types.str;
      default = null;
      description = "Group to run the git operations as";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.remoteAddresses != null && cfg.remoteAddresses != [ ];
        message = "services.git-pull-timer.remoteAddresses must be set and non-empty";
      }
      {
        assertion = cfg.user != null;
        message = "services.git-pull-timer.user must be set";
      }
      {
        assertion = cfg.group != null;
        message = "services.git-pull-timer.group must be set";
      }
    ];

    systemd.services.git-pull-timer = {
      description = "Pull git repository";
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = [
          "+${pkgs.coreutils}/bin/mkdir -p ${cfg.directory}"
          "+${pkgs.coreutils}/bin/chown -R ${cfg.user}:${cfg.group} ${cfg.directory}"
        ];
        ExecStart = pkgs.writeShellScript "git-pull-script" ''
          set -e
          cd ${cfg.directory}

          # Check if this is a git repository
          if ! ${pkgs.git}/bin/git rev-parse --git-dir > /dev/null 2>&1; then
            echo "No git repository found, attempting to clone..."
            
            # Try each remote address in order
            success=false
            ${concatMapStringsSep "\n" (addr: ''
              if [ "$success" = "false" ]; then
                echo "Trying to clone from: ${addr}"
                if ${pkgs.git}/bin/git clone ${addr} . 2>/dev/null; then
                  echo "Successfully cloned from: ${addr}"
                  success=true
                else
                  echo "Failed to clone from: ${addr}"
                fi
              fi
            '') cfg.remoteAddresses}
            
            if [ "$success" = "false" ]; then
              echo "All clone attempts failed"
              exit 1
            fi
          else
            echo "Git repository exists, pulling updates..."
            
            # Check if there are unstaged changes
            if ! ${pkgs.git}/bin/git diff --quiet; then
              echo "Unstaged changes detected, stashing..."
              ${pkgs.git}/bin/git stash push -m "Auto-stash before pull $(date)"
            fi
            
            # Check if there are staged changes
            if ! ${pkgs.git}/bin/git diff --cached --quiet; then
              echo "Staged changes detected, pulling with rebase..."
              ${pkgs.git}/bin/git pull --rebase
            else
              echo "No staged changes, doing regular pull..."
              ${pkgs.git}/bin/git pull
            fi
          fi
        '';
        User = cfg.user;
        Group = cfg.group;
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };

    systemd.timers.git-pull-timer = {
      description = "Timer for git pull service";
      timerConfig =
        {
          OnCalendar = cfg.onCalendar;
          Persistent = cfg.persistent;
        }
        // optionalAttrs cfg.onBoot {
          OnBootSec = "5min";
        };
      wantedBy = [ "timers.target" ];
    };
  };
}
