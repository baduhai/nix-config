{ inputs, lib, ... }:

{
  flake.homeConfigurations."user@rotterdam" = {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = {
      inherit inputs;
      hostname = "rotterdam";
    };
    modules = [
      { nixpkgs.overlays = [ inputs.self.overlays.default ]; }
      {
        home = {
          username = "user";
          homeDirectory = "/home/user";
          stateVersion = "22.05";
        };
      }
      ((inputs.import-tree.initFilter (p: lib.hasSuffix ".nix" p)) ./_user)
    ]
    ++ (with inputs.self.modules.homeManager; [
      # system aspects
      base
      cli
      desktop
      gaming

      # other aspects
      stylix
      niri
    ]);
  };
}
