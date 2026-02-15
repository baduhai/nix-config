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
        inputs.zen-browser.packages."${pkgs.system}".default
        bitwarden-desktop
        fragments
        nextcloud-client
        tor-browser
        vesktop
      ];
    };
}
