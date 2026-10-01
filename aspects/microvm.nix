{ inputs, ... }:
{
  flake.modules.nixos.microvm =
    { ... }:
    {
      imports = [ inputs.microvm.nixosModules.host ];
    };
}
