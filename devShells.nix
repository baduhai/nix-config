{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          agenix
          deploy-rs
          nil
          nixfmt-rfc-style
        ];
      };
    };
}
