{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
        ];
        shellHook = ''
          alias deploy='${inputs.deploy-rs.packages.${pkgs.system}.default}/bin/deploy --skip-checks'
        '';
      };
    };
}
