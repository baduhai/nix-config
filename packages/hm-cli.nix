{
  pkgs ? import <nixpkgs> { },
}:

pkgs.writeShellScriptBin "hm" ''
    set -e

    HM="${pkgs.lib.getExe pkgs.home-manager}"
    FLAKE_PATH="''${HM_PATH:-$HOME/.config/home-manager}"
    FLAKE_OUTPUT="''${HM_USER:-$(whoami)@$(hostname)}"

    show_usage() {
      cat <<EOF
  Usage: hm <command> [args]

  Commands:
    apply                       Switch to a new generation
    generation list             List all generations
    generation delete ID...     Delete specified generation(s)
    generation rollback         Rollback to the previous generation
    generation switch ID        Switch to the specified generation
    generation cleanup          Delete all but the current generation

  Environment Variables:
    HM_PATH           Override default flake path (~/.config/home-manager)
      Currently set to "''${HM_PATH:-<not set>}"
    HM_USER           Override default user output ("$(whoami)@$(hostname)")
      Currently set to "''${HM_USER:-<not set>}"
  EOF
    }

    if [[ $# -eq 0 ]]; then
      show_usage
      exit 1
    fi

    case "$1" in
      apply)
        "$HM" switch --flake "$FLAKE_PATH#$FLAKE_OUTPUT" -b bkp
        ;;
      generation)
        if [[ $# -lt 2 ]]; then
          echo "Error: generation command requires a subcommand"
          show_usage
          exit 1
        fi

        case "$2" in
          list)
            "$HM" generations
            ;;
          delete)
            if [[ $# -lt 3 ]]; then
              echo "Error: delete requires at least one generation ID"
              exit 1
            fi
            shift 2
            "$HM" remove-generations "$@"
            ;;
          rollback)
            PREV_GEN=$("$HM" generations | \
              sed -n 's/^[[:space:]]*id \([0-9]\+\).*/\1/p' | \
              head -n 2 | tail -n 1)
            if [[ -z "$PREV_GEN" ]]; then
              echo "Error: could not determine previous generation (possibly only one generation exists)"
              exit 1
            fi
            "$HM" switch --flake "$FLAKE_PATH" --switch-generation "$PREV_GEN" -b bkp
            ;;
          switch)
            if [[ $# -ne 3 ]]; then
              echo "Error: switch requires exactly one generation ID"
              exit 1
            fi
            "$HM" switch --flake "$FLAKE_PATH" --switch-generation "$3" -b bkp
            ;;
          cleanup)
            CURRENT_GEN=$("$HM" generations | sed -n 's/^.*id \([0-9]\+\) .* (current)$/\1/p')
            if [[ -z "$CURRENT_GEN" ]]; then
              echo "Error: could not determine current generation"
              exit 1
            fi
            OLD_GENS=$("$HM" generations | sed -n 's/^.*id \([0-9]\+\) .*/\1/p' | grep -v "^$CURRENT_GEN$")
            if [[ -z "$OLD_GENS" ]]; then
              echo "No old generations to delete"
            else
              echo "Deleting generations: $(echo $OLD_GENS | tr '\n' ' ')"
              echo "$OLD_GENS" | xargs "$HM" remove-generations
              echo "Cleanup complete. Current generation $CURRENT_GEN preserved."
            fi
            ;;
          *)
            echo "Error: unknown generation subcommand '$2'"
            show_usage
            exit 1
            ;;
        esac
        ;;
      *)
        echo "Error: unknown command '$1'"
        show_usage
        exit 1
        ;;
    esac
''
