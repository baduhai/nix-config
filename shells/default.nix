{ inputs, ... }:

{
  perSystem =
    { pkgs, system, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          inputs.agenix.packages.${stdenv.hostPlatform.system}.default
          nil
          nixfmt
        ];
      };
    };
}
