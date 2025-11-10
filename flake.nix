{
  description = "My nix hosts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    disko.url = "github:nix-community/disko";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nixos-cli.url = "github:nix-community/nixos-cli";

    nix-flatpak.url = "github:gmodena/nix-flatpak/main";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    impermanence.url = "github:nix-community/impermanence";

    deploy-rs.url = "github:serokell/deploy-rs";

    niri-flake.url = "github:sodiboo/niri-flake";

    niri.url = "github:baduhai/niri/auto-center-when-space-available";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ai-tools.url = "github:numtide/nix-ai-tools";

    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./deploy.nix
        ./devShells.nix
        ./homeConfigurations.nix
        ./nixosConfigurations.nix
        ./nixosModules.nix
        ./overlays.nix
        ./packages.nix
        ./terranixConfigurations.nix
      ];
    };
}
