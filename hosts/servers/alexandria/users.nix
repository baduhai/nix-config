{ config, pkgs, ... }:

{
  users.users = {
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL foxtrot@rotterdam" ];
      hashedPassword = "";
    };
    root.hashedPassword = "!";
  };
}
