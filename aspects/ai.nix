{ ... }:
{
  flake.modules.nixos.ai = { inputs, pkgs, ... }: {
    environment.systemPackages =
      (with pkgs; [claude-desktop]) ++
      (with inputs.nix-ai-tools.packages.${pkgs.system}; [
        claude-code
        claudebox
        opencode
      ]);
  };
}
