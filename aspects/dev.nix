{ ... }:
{
  flake.modules.nixos.dev =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        android-tools
        lazygit
        fd
        fzf
        nixfmt
        nix-init
        ripgrep
      ];

      users.users.user.extraGroups = [ "adbusers" ];
    };
}
