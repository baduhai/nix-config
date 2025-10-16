{ inputs }:
let
  inherit (inputs)
    self
    nixpkgs
    nixpkgs-stable
    home-manager
    agenix
    ;
in
{
  # Tag-based host configuration system
  mkHost =
    {
      hostname,
      tags ? [ ],
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    let
      # Validate that server and desktop tags are mutually exclusive
      hasServer = builtins.elem "server" tags;
      hasDesktop = builtins.elem "desktop" tags;

      # Always include "common" tag implicitly
      allTags =
        if hasServer && hasDesktop then
          throw "Error: 'server' and 'desktop' tags are mutually exclusive for host '${hostname}'"
        else
          [ "common" ] ++ tags;

      # Choose nixpkgs based on server tag
      pkgs = if builtins.elem "server" allTags then nixpkgs-stable else nixpkgs;

      # Tag-specific modules: each tag can be either:
      # 1. A file: hosts/modules/${tag}.nix
      # 2. A directory: hosts/modules/${tag}/*.nix (all .nix files imported)
      tagModuleFiles = builtins.concatMap (
        tag:
        let
          filePath = ./hosts/modules/${tag}.nix;
          dirPath = ./hosts/modules/${tag};
        in
        # Check if it's a file first
        if builtins.pathExists filePath then
          [ filePath ]
        # Then check if it's a directory
        else if builtins.pathExists dirPath then
          let
            entries = builtins.readDir dirPath;
            nixFiles = pkgs.lib.filterAttrs (
              name: type: type == "regular" && pkgs.lib.hasSuffix ".nix" name
            ) entries;
          in
          map (name: dirPath + "/${name}") (builtins.attrNames nixFiles)
        else
          [ ]
      ) allTags;

      # Automatically import all .nix files from hosts/${hostname}/
      hostModulePath = ./hosts/${hostname};
      hostModuleFiles =
        if builtins.pathExists hostModulePath then
          let
            entries = builtins.readDir hostModulePath;
            nixFiles = pkgs.lib.filterAttrs (
              name: type: type == "regular" && pkgs.lib.hasSuffix ".nix" name && name != "${hostname}.nix"
            ) entries;
          in
          map (name: hostModulePath + "/${name}") (builtins.attrNames nixFiles)
        else
          [ ];

      # Combine all modules
      allModules = [
        agenix.nixosModules.default
        {
          networking.hostName = hostname;
          nix.nixPath = [ "nixos-config=${self.outPath}/nixosConfigurations/${hostname}" ];
          nixpkgs.overlays = [
            agenix.overlays.default
            self.overlays.default
          ];
        }
      ]
      ++ tagModuleFiles
      ++ hostModuleFiles
      ++ extraModules;
    in
    pkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        hostTags = allTags;
      };
      modules = allModules;
    };

  # Tag-based user configuration system
  mkHome =
    {
      username,
      homeDirectory ? "/home/${username}",
      tags ? [ ],
      extraModules ? [ ],
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # Always include "common" tag implicitly
      allTags = [ "common" ] ++ tags;

      # Tag-specific modules: each tag maps to users/modules/${tag}.nix if it exists
      tagModuleFiles = builtins.concatMap (
        tag:
        let
          filePath = ./users/modules/${tag}.nix;
          dirPath = ./users/modules/${tag};
        in
        # Check if it's a file first
        if builtins.pathExists filePath then
          [ filePath ]
        # Then check if it's a directory
        else if builtins.pathExists dirPath then
          let
            entries = builtins.readDir dirPath;
            nixFiles = pkgs.lib.filterAttrs (
              name: type: type == "regular" && pkgs.lib.hasSuffix ".nix" name
            ) entries;
          in
          map (name: dirPath + "/${name}") (builtins.attrNames nixFiles)
        else
          [ ]
      ) allTags;

      # Automatically import all .nix files from users/${username}/
      userModulePath = ./users/${username};
      userModuleFiles =
        if builtins.pathExists userModulePath then
          let
            entries = builtins.readDir userModulePath;
            nixFiles = pkgs.lib.filterAttrs (
              name: type: type == "regular" && pkgs.lib.hasSuffix ".nix" name
            ) entries;
          in
          map (name: userModulePath + "/${name}") (builtins.attrNames nixFiles)
        else
          [ ];

      # Combine all modules
      allModules = [
        {
          home = {
            inherit username homeDirectory;
            stateVersion = "22.05";
          };
        }
      ]
      ++ tagModuleFiles
      ++ userModuleFiles
      ++ extraModules;
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
        userTags = allTags;
      };
      modules = allModules ++ [
        {
          nixpkgs.overlays = [ self.overlays.default ];
        }
      ];
    };
}
