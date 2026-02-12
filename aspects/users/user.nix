{ inputs, self, ... }:

{
  flake = {
    modules.nixos.user =
      { pkgs, ... }:
      {
        users.users.user = {
          isNormalUser = true;
          shell = pkgs.fish;
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQPkAyy+Du9Omc2WtnUF2TV8jFAF4H6mJi2D4IZ1nzg user@himalia"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3Y0PVpGfJHonqDS7qoCFhqzUvqGq9I9sax+F9e/5cs user@io"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA1v3+q3EaruiiStWjubEJWvtejam/r41uoOpCdwJtLL user@rotterdam"
          ];
          hashedPassword = "$6$Pj7v/CpstyuWQQV0$cNujVDhfMBdwlGVEnnd8t71.kZPixbo0u25cd.874iaqLTH4V5fa1f98V5zGapjQCz5JyZmsR94xi00sUrntT0";
        };
      };

    homeConfigurations = {
      "user@rotterdam" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          hostname = "rotterdam";
        };
        modules = [
          { nixpkgs.overlays = [ inputs.self.overlays.default ]; }

          # CLI aspects (common module included)
          inputs.self.modules.homeManager.cli-base
          inputs.self.modules.homeManager.cli-btop
          inputs.self.modules.homeManager.cli-comma
          inputs.self.modules.homeManager.cli-direnv
          inputs.self.modules.homeManager.cli-helix
          inputs.self.modules.homeManager.cli-starship
          inputs.self.modules.homeManager.cli-tmux

          # Shell
          inputs.self.modules.homeManager.shell-fish
          inputs.self.modules.homeManager.shell-bash

          # Desktop
          inputs.self.modules.homeManager.desktop-desktop
          inputs.self.modules.homeManager.desktop-niri

          # Gaming
          inputs.self.modules.homeManager.gaming-mangohud

          # Programs
          inputs.self.modules.homeManager.programs-media # for obs-studio

          # Stylix
          inputs.self.modules.homeManager.stylix

          # User-specific (from _user/)
          ./_user/git.nix

          # Home configuration
          {
            home = {
              username = "user";
              homeDirectory = "/home/user";
              stateVersion = "22.05";
            };
          }
        ];
      };

      "user@io" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
          hostname = "io";
        };
        modules = [
          { nixpkgs.overlays = [ inputs.self.overlays.default ]; }

          # CLI aspects (common module included)
          inputs.self.modules.homeManager.cli-base
          inputs.self.modules.homeManager.cli-btop
          inputs.self.modules.homeManager.cli-comma
          inputs.self.modules.homeManager.cli-direnv
          inputs.self.modules.homeManager.cli-helix
          inputs.self.modules.homeManager.cli-starship
          inputs.self.modules.homeManager.cli-tmux

          # Shell
          inputs.self.modules.homeManager.shell-fish
          inputs.self.modules.homeManager.shell-bash

          # Desktop
          inputs.self.modules.homeManager.desktop-desktop
          inputs.self.modules.homeManager.desktop-niri

          # Stylix
          inputs.self.modules.homeManager.stylix

          # User-specific (from _user/)
          ./_user/git.nix

          # Home configuration
          {
            home = {
              username = "user";
              homeDirectory = "/home/user";
              stateVersion = "22.05";
            };
          }
        ];
      };
    };
  };
}
