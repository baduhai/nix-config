{ inputs, ... }:

{
  flake.modules = {
    nixos.cli =
      { ... }:
      {
        imports = with inputs.self.modules.nixos; [
          btop
          helix
          tmux
        ];
      };
    homeManager.cli =
      { ... }:
      {
        imports = with inputs.self.modules.nixos; [
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
