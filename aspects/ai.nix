{ ... }:
{
  flake.modules.nixos.ai =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [ ])
        ++ (with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
          claude-code
          claudebox
          opencode
        ]);
    };
}
