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
      ls = "${lib.getExe pkgs.eza} --icons --group-directories-first";
      tree = "ls --tree";
    };
  };

  programs = {
    command-not-found.enable = false;
    fish.enable = true;
  };
}
