{ ... }:

{
  flake.modules.nixos.programs-office = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # Spelling
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.pt_BR
      # Document Viewing
      papers
      # Presentations
      presenterm
      # Note Taking & Drawing
      rnote
    ];

    services.flatpak.packages = [
      # Office Suite
      "com.collabora.Office"
    ];
  };
}
