{ ... }:

{
  imports = [
    ./forgejo.nix
    ./hardware-configuration.nix
    ./jellyfin.nix
    ./librespeed.nix
    ./nginx.nix
    ./services.nix
    ./users.nix
    ./vaultwarden.nix
  ];
}
