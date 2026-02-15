{ inputs, ... }:

{
  flake.modules = {
    nixos.cli =
      { pkgs, ... }:
      {
        imports = with inputs.self.modules.nixos; [
          btop
          helix
          tmux
        ];

        environment.systemPackages = with pkgs; [
          p7zip
          rclone
        ];
      };
    homeManager.cli =
      { ... }:
      {
        imports = with inputs.self.modules.homeManager; [
          btop
          comma
          direnv
          helix
          hm-cli
          starship
          tmux
        ];
      };
  };
}
