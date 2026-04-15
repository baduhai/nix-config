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
            # Expand !! and !$ on space (Fish-style)
            bindkey ' ' magic-space
            setopt HIST_VERIFY
            # History prefix search with up/down arrows
            bindkey "^[[A" history-search-backward
            bindkey "^[[B" history-search-forward
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
            # Ctrl+Arrow Keys to move back and forward by a word
            bindkey "^[[1;5D" backward-word
            bindkey "^[[1;5C" forward-word
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
