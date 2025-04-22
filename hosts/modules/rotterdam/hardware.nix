{ pkgs, ... }:

{
  hardware = {
    amdgpu = {
      opencl.enable = true;
      amdvlk.enable = true;
    };
    graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };
}
