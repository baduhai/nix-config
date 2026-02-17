{ ... }:
{
  flake.modules.nixos.nix =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.nixos-cli.nixosModules.nixos-cli
        inputs.determinate.nixosModules.default
      ];

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 8d";
      };

      environment.etc."nix/nix.custom.conf".text = ''
        auto-optimise-store = true
        connect-timeout = 10
        log-lines = 25
        min-free = 128000000
        max-free = 1000000000
        trusted-users = @wheel
      '';

      nixpkgs.config = {
        allowUnfree = true;
        enableParallelBuilding = true;
        buildManPages = false;
        buildDocs = false;
      };

      services.nixos-cli = {
        enable = true;
        config = {
          use_nvd = true;
          ignore_dirty_tree = true;
          apply = {
            reexec_as_root = true;
            use_nom = true;
          };
          confirmation.empty = "default-yes";
        };
      };

      environment.systemPackages = with pkgs; [
        nix-output-monitor
        nvd
      ];

      system.stateVersion = "22.11";
    };
}
