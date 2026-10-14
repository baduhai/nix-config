{ ... }:
{
  flake.modules = {
    nixos.zsh =
      { lib, pkgs, ... }:
      {
        # System-wide zsh config: lands in /etc/zshrc, which every interactive
        # shell reads before ~/.zshrc. This gives bare NixOS hosts the shell
        # settings even when no home-manager profile is installed, while
        # home-manager keeps only its own additions (starship, zoxide, ...).
        programs.zsh = {
          enable = true;
          # Ship nix-zsh-completions and link /share/zsh for every user.
          enableCompletion = true;
          # We run our own `compinit -C` in interactiveShellInit below. Skipping
          # compaudit saves ~35ms per shell and buys nothing on NixOS, where the
          # fpath dirs are root-owned.
          enableGlobalCompInit = false;
          # The built-in "suse" prompt only runs to be overwritten by starship.
          promptInit = "";
          autosuggestions = {
            enable = true;
            strategy = [
              "match_prev_cmd"
              "completion"
            ];
          };
          syntaxHighlighting.enable = true;
          histSize = 10000;
          setOptions = [
            "HIST_IGNORE_DUPS"
            "HIST_IGNORE_SPACE"
            "SHARE_HISTORY"
            "HIST_FCNTL_LOCK"
            "NO_BEEP"
          ];
          interactiveShellInit = ''
            zstyle ':completion:*' menu select
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
            autoload -Uz compinit && compinit -C
            ${lib.getExe pkgs.nix-your-shell} zsh | source /dev/stdin
            # Expand !! and !$ in place (Fish-style): on space, and on Enter.
            # Without this, HIST_VERIFY re-prints the expanded line at a fresh
            # prompt (a new line); accepting it here rewrites the current line.
            bindkey ' ' magic-space
            setopt HIST_VERIFY
            function expand-history-accept-line() {
              local before=$BUFFER
              zle .expand-history
              # Re-expand first; only run once nothing is left to expand, so
              # the expansion stays on the current line for review.
              [[ "$BUFFER" == "$before" ]] && zle .accept-line
            }
            zle -N accept-line expand-history-accept-line
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
        };
      };
    homeManager.zsh =
      { config, ... }:
      {
        # Home-manager only adds what the system-wide /etc/zshrc does not:
        # the shell plugins, widgets and history options are set in nixos.zsh.
        programs.zsh = {
          enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          # compinit already ran system-wide; don't run it a second time.
          enableCompletion = false;
          # The home-manager zsh module always writes the history variables, so
          # keep them matching the system-wide values to avoid overriding them.
          history = {
            size = 10000;
            save = 10000;
            share = true;
          };
        };
      };
  };
}
