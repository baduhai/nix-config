{ ... }:
{
  flake.modules.nixos.common-programs =
    { lib, pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          ### Dev Tools ###
          git
          ### System Utilities ###
          btop
          fastfetch
          helix
          nixos-firewall-tool
          nvd
          sysz
          tmux
          wget
          yazi
        ];
        shellAliases = {
          cat = "${lib.getExe pkgs.bat} --paging=never --style=plain";
          ls = "${lib.getExe pkgs.eza} --git --icons --group-directories-first";
          tree = "ls --tree";
        };
      };

      programs = {
        command-not-found.enable = false;
        fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting
            if set -q SSH_CONNECTION; and not set -q IN_NIX_SHELL; or not set -q TMUX
              export TERM=xterm-256color
              clear
              fastfetch
            end
          '';
        };
      };
    };
}
