{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    claude-code
    lazygit
    fd
    fzf
    glow
    nixfmt-rfc-style
    nix-init
    nix-output-monitor
    ripgrep
  ];

  programs.adb.enable = true;

  users.users.user.extraGroups = [ "adbusers" ];
}
