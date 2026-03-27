{ ... }:
{
  flake.modules = {
    nixos.zsh =
      { ... }:
      {
        programs.zsh.enable = true;
      };
    homeManager.zsh =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        programs.zsh = {
          enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          autosuggestion = {
            enable = true;
            strategy = [
              "match_prev_cmd"
              "completion"
            ];
          };
          enableCompletion = true;
          syntaxHighlighting.enable = true;
          initExtra = ''
            unsetopt beep
            ${lib.getExe pkgs.nix-your-shell} zsh | source /dev/stdin

            # Fish-style Ctrl+Backspace: delete one path segment at a time
            function backward-kill-path-component() {
              if [[ "$LBUFFER" == */ ]]; then
                LBUFFER="''${LBUFFER%/}"
              fi

              if [[ "$LBUFFER" == */* ]]; then
                LBUFFER="''${LBUFFER%/*}/"
              else
                zle backward-kill-word
              fi
            }
            zle -N backward-kill-path-component
            bindkey '^H' backward-kill-path-component
          '';
          loginExtra = "${lib.getExe pkgs.nix-your-shell} zsh | source /dev/stdin";
          history = {
            size = 10000;
            save = 10000;
            share = true;
          };
          initExtraBeforeCompInit = ''
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
          '';
        };
      };
  };
}
