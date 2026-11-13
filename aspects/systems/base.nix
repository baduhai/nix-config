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
            # Ghostty's terminfo entry, so hosts know TERM=xterm-ghostty.
            # NixOS's set-environment points TERMINFO_DIRS at the profile
            # terminfo dirs, so without this every ssh login from Ghostty
            # warns "can't find terminal definition for xterm-ghostty"
            # and terminfo-aware tools misbehave.
            ghostty.terminfo
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
