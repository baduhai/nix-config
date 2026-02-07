{ ... }:

{
  services = {
    openssh = {
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    fail2ban.jails.sshd = {
      settings = {
        enabled = true;
        port = "ssh";
        filter = "sshd";
        logpath = "/var/log/auth.log";
        maxretry = 3;
        findtime = "10m";
        bantime = "1h";
      };
    };
  };
}
