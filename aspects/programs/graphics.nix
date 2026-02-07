{ ... }:

{
  flake.modules.nixos.programs-graphics =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gimp
        inkscape
        plasticity
      ];

      services.flatpak.packages = [
        "com.boxy_svg.BoxySVG"
        rec {
          appId = "io.github.softfever.OrcaSlicer";
          sha256 = "0hdx5sg6fknj1pfnfxvlfwb5h6y1vjr6fyajbsnjph5gkp97c6p1";
          bundle = "${pkgs.fetchurl {
            url = "https://github.com/SoftFever/OrcaSlicer/releases/download/v2.3.0/OrcaSlicer-Linux-flatpak_V2.3.0_x86_64.flatpak";
            inherit sha256;
          }}";
        }
      ];
    };
}
