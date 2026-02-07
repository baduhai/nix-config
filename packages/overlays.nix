{ inputs, ... }:

{
  flake.overlays.default = final: prev: {
    base16-schemes = inputs.self.packages.${final.system}.base16-schemes;
    claude-desktop = inputs.self.packages.${final.system}.claude-desktop;
    fastfetch = inputs.self.packages.${final.system}.fastfetch;
    hm-cli = inputs.self.packages.${final.system}.hm-cli;
    kwrite = inputs.self.packages.${final.system}.kwrite;
    toggleaudiosink = inputs.self.packages.${final.system}.toggleaudiosink;
  };
}
