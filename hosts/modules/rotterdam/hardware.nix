{ pkgs, ... }:

{
  hardware = {
    amdgpu.opencl.enable = true;
    graphics.extraPackages = with pkgs; [ rocmPackages.clr.icd ];
  };
}
