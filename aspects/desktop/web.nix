{ ... }:

{
  flake.modules.nixos.web =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
        amnesiac-brave
        beeper
        bitwarden-desktop
        qbittorrent
        nextcloud-client
        vesktop
      ];
    };
}
