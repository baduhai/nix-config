{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      # The command itself lives in hm-cli.sh so it stays readable and can be
      # linted by shellcheck (writeShellApplication runs it at build time).
      packages.hm-cli = pkgs.writeShellApplication {
        name = "hm";
        runtimeInputs = with pkgs; [
          coreutils
          gnugrep
          gnused
          home-manager
          nix
          util-linux
        ];
        text = builtins.readFile ./hm-cli.sh;
      };
    };
}
