{ inputs, ... }:

{
  flake.overlays = {
    default = final: prev: {
      # plasticity = inputs.self.packages.${final.system}.plasticity;
      toggleaudiosink = inputs.self.packages.${final.system}.toggleaudiosink;
    };
  };
}
