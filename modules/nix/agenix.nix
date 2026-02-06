{
  self,
  inputs,
  ...
}:
{
  flake-file.inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    secrets = {
      url = "path:./secrets";
      flake = false;
    };
  };

  flake.modules = {
    nixos.secrets =
      { pkgs, ... }:
      {
        imports = [
          inputs.agenix.nixosModules.default
        ];
        environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };

    # homeManager.secrets =
    #   { pkgs, ... }:
    #   {
    #     imports = [
    #       inputs.agenix.homeManagerModules.default
    #     ];
    #   };
  };
}
