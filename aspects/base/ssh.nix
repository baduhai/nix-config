{ ... }:

{
  flake.modules.nixos.ssh =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
        extraConfig = ''
          PrintLastLog no
        '';
      };
      programs = {
        bash.interactiveShellInit = ''
          if { [ -n "$SSH_CONNECTION" ] && [ -z "$IN_NIX_SHELL" ]; } || [ -z "$TMUX" ]; then
            export TERM=xterm-256color
            clear
            fastfetch
          fi
        '';
        fish.interactiveShellInit = ''
          set fish_greeting
          if set -q SSH_CONNECTION; and not set -q IN_NIX_SHELL; or not set -q TMUX
            export TERM=xterm-256color
            clear
            fastfetch
          end
        '';
      };
    };
}
