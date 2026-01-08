{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    android-tools
    bat
    lazygit
    fd
    fzf
    glow
    nixfmt
    nix-init
    nix-output-monitor
    ripgrep
  ];

  users.users.user.extraGroups = [ "adbusers" ];
}
