{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      proc_sorting = "cpu direct";
      update_ms = 500;
    };
  };
}