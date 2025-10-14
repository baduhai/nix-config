{ ... }:

{
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "/run/radicale/radicale.sock" ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/etc/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
    };
  };
}
