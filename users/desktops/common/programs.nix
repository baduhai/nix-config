{ specialArgs, inputs, config, pkgs, lib, ... }:

{
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = { name = "Inter"; size = 10; };
    theme = { package = pkgs.breeze-gtk; name = "Breeze"; };
    iconTheme = { package = pkgs.breeze-icons; name = "Breeze"; };
  };

  programs = {
    password-store.package = pkgs.pass-wayland;
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
    git = {
      enable = true;
      diff-so-fancy.enable = true;
      userName = "William";
      userEmail = "williamhai@hotmail.com";
    };
    fish = {
      shellAliases.ssh = "kitty +kitten ssh";
      functions = {
        rebuild = "rm ~/.gtkrc-2.0; sudo nixos-rebuild switch --flake '/home/user/Projects/personal/nix-config#'";
        rebuild-boot = "rm ~/.gtkrc-2.0; sudo nixos-rebuild boot --flake '/home/user/Projects/personal/nix-config#'";
        upgrade = "rm ~/.gtkrc-2.0; nix flake lock --update-input nixpkgs --commit-lock-file /home/user/Projects/personal/nix-config; sudo nixos-rebuild switch --upgrade --flake '/home/user/Projects/personal/nix-config#'";
        upgrade-boot = "rm ~/.gtkrc-2.0; nix flake lock --update-input nixpkgs --commit-lock-file /home/user/Projects/personal/nix-config; sudo nixos-rebuild boot --upgrade --flake '/home/user/Projects/personal/nix-config#'";
      };
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox_dark.theme";
        theme_background = false;
        proc_sorting = "cpu direct";
        update_ms = 500;
      };
    };
    kitty = {
      enable = true;
      theme = "Afterglow";
      font = {
        name = "Hack Nerd Font";
        size = 10;
      };
      keybindings = {
        "kitty_mod+f" = "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
      };
      settings = {
        clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
        confirm_os_window_close = "-2";
        cursor_shape = "block";
        initial_window_height = "570";
        initial_window_width = "120c";
        remember_window_size = "no";
        tab_bar_background = "#3b3b3b";
        tab_bar_margin_color = "#3b3b3b";
        tab_bar_margin_height = "3 3";
        tab_bar_margin_width = 2;
        tab_bar_min_tabs = 1;
        tab_bar_style = "fade";
        tab_fade = 0;
        tab_switch_strategy = "left";
        tab_title_template = "{fmt.bg._3b3b3b}{fmt.fg._202020}{fmt.fg.default}{fmt.bg._202020}{fmt.fg._c6c6c6} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg._202020}{fmt.fg.default}";
        active_tab_title_template = "{fmt.bg._3b3b3b}{fmt.fg._fcfcfc}{fmt.fg.default}{fmt.bg._fcfcfc}{fmt.fg._3b3b3b} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg._fcfcfc}{fmt.fg.default}";
      };
    };
  };
}
