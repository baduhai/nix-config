{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          agenix-cli
          deploy-rs
          nil
          nixfmt-rfc-style
        ];
      };
    };
}
