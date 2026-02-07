{ ... }:

{
  flake.modules.nixos.root =
    { pkgs, ... }:
    {
      users.root = {
        shell = pkgs.fish;
        hashedPassword = "!";
      };
    };
}
