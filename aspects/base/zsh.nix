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
            # History prefix search with up/down arrows (Fish-style, cursor at end)
            autoload -U history-search-end
            zle -N history-beginning-search-backward-end history-search-end
            zle -N history-beginning-search-forward-end history-search-end
            bindkey "^[[A" history-beginning-search-backward-end
            bindkey "^[[B" history-beginning-search-forward-end
            bindkey "^[OA" history-beginning-search-backward-end
            bindkey "^[OB" history-beginning-search-forward-end
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
