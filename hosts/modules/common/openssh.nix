{ ... }:

{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    extraConfig = ''
      PrintLastLog no
    '';
  };
}
