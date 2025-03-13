{
  inputs,
  lib,
  hostType,
  ...
}:

{
  config = lib.mkMerge [
    # Common configuration
    {
      nix = {
        settings = {
          auto-optimise-store = true;
          connect-timeout = 10;
          log-lines = 25;
          min-free = 128000000;
          max-free = 1000000000;
          trusted-users = [ "@wheel" ];
        };
        extraOptions = "experimental-features = nix-command flakes";
        gc = {
          automatic = true;
          options = "--delete-older-than 8d";
        };
      };

      nixpkgs.config = {
        allowUnfree = true;
        enableParallelBuilding = true;
        buildManPages = false;
        buildDocs = false;
      };

      system.stateVersion = "22.11";
    }

    # Server specific configuration
    (lib.mkIf hostType.isServer {
      environment.etc."channels/nixpkgs".source = inputs.nixpkgs-stable.outPath;

      nix = {
        registry.nixpkgs.flake = inputs.nixpkgs-stable;
        nixPath = [
          "nixpkgs=/etc/channels/nixpkgs"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
      };
    })

    # Workstation specific configuration
    (lib.mkIf hostType.isWorkstation {
      environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

      nix = {
        registry.nixpkgs.flake = inputs.nixpkgs;
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
      };
    })
  ];
}
