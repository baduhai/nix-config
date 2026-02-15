{ ... }:

{
  flake.modules.nixos.user =
    { pkgs, ... }:
    {
      users.users.user = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQPkAyy+Du9Omc2WtnUF2TV8jFAF4H6mJi2D4IZ1nzg user@himalia"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs user@io"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL user@rotterdam"
        ];
        hashedPassword = "$6$Pj7v/CpstyuWQQV0$cNujVDhfMBdwlGVEnnd8t71.kZPixbo0u25cd.874iaqLTH4V5fa1f98V5zGapjQCz5JyZmsR94xi00sUrntT0";
      };
    };
}
