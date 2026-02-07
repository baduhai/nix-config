# aspects/users/user.nix
{ inputs, ... }:
{
  flake.homeConfigurations = {
    "user@rotterdam" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; hostname = "rotterdam"; };
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
      extraSpecialArgs = { inherit inputs; hostname = "io"; };
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
}
