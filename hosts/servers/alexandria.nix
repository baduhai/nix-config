{ config, pkgs, lib, ...}:

{
  imports = [
    # Host-common imports
    ../common
    # Server-common imports
    ./common
    # Host-specific imports
    ./alexandria
  ];

  users.users.user.extraGroups = [ "docker" ];

  nix.nixPath = [ "nixos-config=${./alexandria.nix}" ];

  swapDevices = [ { device = "/swapfile"; size = 8192; } ];

  networking = {
    hostName = "alexandria";
    firewall = {
      allowedTCPPorts = [
        80
        443
        9666
      ];
    };
  };

  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    openFirewall = true;
    package = pkgs.papermc;
    serverProperties = {
      motd = "Bem-vindo a Alexandria";
      difficulty = "hard";
      gamemode = "survival";
    };
    dataDir = "/data/minecraft";
  };
}
