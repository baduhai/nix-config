{ ... }:

{
  flake.modules.nixos.programs-web = { inputs, pkgs, system, ... }: {
    environment.systemPackages = with pkgs; [
      # Browsers
      inputs.zen-browser.packages."${system}".default
      tor-browser
      # Communication
      vesktop
      # Cloud & Sync
      bitwarden-desktop
      nextcloud-client
      # Downloads
      fragments
    ];
  };
}
