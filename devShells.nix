{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
          deploy-rs
        ];
      };
    };
}
