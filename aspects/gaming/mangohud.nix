{ ... }:

{
  flake.modules = {
    nixos.mangohud =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mangohud
        ];
      };

    homeManager.mangohud =
      { config, ... }:
      {
        programs.mangohud = {
          enable = true;
          enableSessionWide = true;
          settings = {
            position = "top-left";
            fps = true;
            frametime = false;
            frame_timing = false;
            gpu_stats = true;
            gpu_temp = true;
            gpu_power = true;
            cpu_stats = true;
            cpu_temp = true;
            cpu_power = true;
            ram = true;
            vram = true;
            gamemode = false;
            vkbasalt = false;
            version = false;
            engine_version = false;
            vulkan_driver = false;
            wine = false;
            time = false;
            fps_sampling_period = 500;
            toggle_hud = "Shift_L+F12";
            toggle_logging = "Ctrl_L+F2";
            output_folder = "${config.home.homeDirectory}/.local/share/mangohud";
          };
        };
      };
  };
}
