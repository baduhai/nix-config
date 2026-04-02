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
        beeper
        bitwarden-desktop
        brave
        qbittorrent
        nextcloud-client
        vesktop
      ];
    };
}
