{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
          inputs.deploy-rs.packages.${pkgs.system}.default
        ];
      };
    };
}
