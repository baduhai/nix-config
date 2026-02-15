{ ... }:

{
  flake.modules.nixos.web =
    {
      inputs,
      pkgs,
      system,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        inputs.zen-browser.packages."${system}".default
        bitwarden-desktop
        fragments
        nextcloud-client
        tor-browser
        vesktop
      ];
    };
}
