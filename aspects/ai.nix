{ ... }:
{
  flake.modules.nixos.ai =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [ opencode ])
        ++ (with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
        ]);
    };
}
