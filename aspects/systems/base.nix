{ inputs, ... }:
{
  flake.modules.nixos.base =
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
      ];
      environment = {
        systemPackages = with pkgs; [
          git
          fastfetch
          nixos-firewall-tool
          sysz
          wget
          yazi
        ];
        shellAliases = {
          cat = "${lib.getExe pkgs.bat} --paging=never --style=plain";
          ls = "${lib.getExe pkgs.eza} --git --icons --group-directories-first";
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
}
