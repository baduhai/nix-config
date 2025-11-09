{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.0/8"
      "::1"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "100.64.0.0/10"
    ];

    bantime = "1h";
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "10000h";
      overalljails = true;
    };

    jails.forgejo = {
      settings = {
        enabled = true;
        filter = "forgejo";
        backend = "systemd";
        maxretry = 10;
        findtime = "1h";
        bantime = "15m";
      };
    };
  };

  # Custom fail2ban filter for Forgejo using systemd journal
  environment.etc."fail2ban/filter.d/forgejo.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
    [Definition]
    journalmatch = _SYSTEMD_UNIT=forgejo.service
    failregex = Failed authentication attempt for .+ from <HOST>:\d+:
    ignoreregex =
  '');
}
