{ ... }:

{
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
  programs.fish.interactiveShellInit = ''
    if set -q SSH_CONNECTION
      neofetch
    end
  '';
}
