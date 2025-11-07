{ inputs, pkgs, ... }:

{
  environment.systemPackages = with inputs.nix-ai-tools.packages.${pkgs.system}; [
    claude-desktop
    claude-code
    claudebox
    opencode
  ];
}
