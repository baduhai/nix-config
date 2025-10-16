{ inputs, ... }:

{
  flake.overlays = {
    default = final: prev: {
      toggleaudiosink = inputs.self.packages.${final.system}.toggleaudiosink;
      hm-cli = inputs.self.packages.${final.system}.hm-cli;
      kwrite = inputs.self.packages.${final.system}.kwrite;
      base16-schemes = inputs.self.packages.${final.system}.base16-schemes;
    };
  };
}
