{ inputs, ... }:
{
  flake.modules = {
    nixos.base =
      { lib, pkgs, ... }:
      {
        imports = with inputs.self.modules.nixos; [
          boot
          console
          firewall
          fish
          locale
          nix
          security
          ssh
          zsh
        ];
        environment = {
          systemPackages = with pkgs; [
            git
            fastfetch
            nixos-firewall-tool
            sysz
            wget
          ];
          shellAliases = {
            cat = "${lib.getExe pkgs.bat} --paging=never --style=plain";
            ls = "${lib.getExe pkgs.eza} --git --icons --group-directories-first";
            la = "ls -hal";
            tree = "ls --tree";
          };
        };

        programs.command-not-found.enable = false;

        services = {
          dbus.implementation = "broker";
          irqbalance.enable = true;
          fstrim.enable = true;
          tailscale = {
            enable = true;
            extraUpFlags = [ "--operator=user" ];
          };
        };
      };

    homeManager.base =
      { ... }:
      {
        imports = with inputs.self.modules.homeManager; [
          bash
          fish
          zsh
        ];
      };
  };
}
