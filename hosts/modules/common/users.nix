{ pkgs, ... }:

{
  users.users = {
    user = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL user@rotterdam"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs user@io"
      ];
      hashedPassword = "$6$Pj7v/CpstyuWQQV0$cNujVDhfMBdwlGVEnnd8t71.kZPixbo0u25cd.874iaqLTH4V5fa1f98V5zGapjQCz5JyZmsR94xi00sUrntT0";
    };
    root = {
      shell = pkgs.fish;
      hashedPassword = "!";
    };
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
}
