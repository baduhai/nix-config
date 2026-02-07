{ inputs, ... }:

let
  packageDir = builtins.readDir ./.;

  # Filter to .nix files, excluding overlays.nix
  isPackageFile = name:
    name != "overlays.nix" && builtins.match ".*\\.nix$" name != null;

  # Extract package name from filename (e.g., "foo-bar.nix" -> "foo-bar")
  toPackageName = filename:
    builtins.head (builtins.match "(.+)\\.nix$" filename);

  packageNames = map toPackageName (builtins.filter isPackageFile (builtins.attrNames packageDir));
in
{
  flake.overlays.default = final: prev:
    builtins.listToAttrs (map (name: {
      inherit name;
      value = inputs.self.packages.${final.system}.${name};
    }) packageNames);
}
