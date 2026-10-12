{ ... }:
{
  flake.modules = {
    nixos.zsh =
      { ... }:
      {
        programs.zsh = {
          enable = true;
          # The home-manager zsh module already extends fpath and runs
          # `compinit -C` (see homeManager.zsh below). The global compinit that
          # NixOS puts in /etc/zshrc duplicates that and pays the full
          # compaudit scan, so turn it off.
          enableGlobalCompInit = false;
          # starship sets the prompt from ~/.zshrc; the built-in "suse" prompt
          # setup in /etc/zshrc only runs to be overwritten.
          promptInit = "";
        };
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
          # Skip compinit's compaudit security scan on every startup; on NixOS
          # fpath dirs are root-owned, so the check buys nothing and costs ~35ms.
          completionInit = "autoload -Uz compinit && compinit -C";
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
