{ ... }:
{
  flake.modules = {
    nixos.btop =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ btop ];
      };

    homeManager.btop =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        programs.btop = {
          enable = true;
          settings = {
            theme_background = false;
            proc_sorting = "cpu direct";
            update_ms = 500;
          };
        };
      };
  };
}
