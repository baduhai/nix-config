{ ... }:
{
  flake.modules.nixos.ai =
    { inputs, pkgs, ... }:
    {
      environment.systemPackages =
        (with pkgs; [ ])
        ++ (with inputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}; [
          opencode
        ]);

      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };
    };
}
