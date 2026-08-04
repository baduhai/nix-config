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
        qbittorrent
        nextcloud-client
        ungoogled-chromium
        vesktop
        zapzap
      ];
    };
}
