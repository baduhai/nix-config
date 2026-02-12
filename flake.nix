{
  description = "My nix hosts";

  inputs = {
    # nix tools
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # nixos/hm
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos/hm functionality modules
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    nixos-cli.url = "github:nix-community/nixos-cli";
    nix-flatpak.url = "github:gmodena/nix-flatpak/main";
    stylix.url = "github:danth/stylix";

    # nixos/hm program modules
    niri-flake.url = "github:sodiboo/niri-flake";
    nix-ai-tools.url = "github:numtide/llm-agents.nix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # stand-alone tools
    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # others
    niri.url = "github:baduhai/niri/auto-center-when-space-available";
  };

  outputs =
    inputs@{ flake-parts, import-tree, ... }:
    let
      aspectsModules = import-tree ./aspects;
      packagesModules = import-tree ./packages;
      shellsModules = import-tree ./shells;
      terranixModules = import-tree ./terranix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        flake-parts.flakeModules.modules
        inputs.terranix.flakeModule
      ]
      ++ aspectsModules.imports
      ++ packagesModules.imports
      ++ shellsModules.imports
      ++ terranixModules.imports;
    };
}
