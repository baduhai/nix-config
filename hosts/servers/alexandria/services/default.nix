{ ... }:

let
  N8N_PORT = "5678";
  BAZAAR_PORT = "6767";
in

{
  imports = [
    ./nginx.nix
    ./containerised.nix
  ];
}
