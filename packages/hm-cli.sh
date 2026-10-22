# hm - a nixos-cli style front-end for home-manager.
#
# The goal is that muscle memory from `nixos` carries over: same subcommand
# names, same aliases, same flag names, same help layout, same error wording.
# Anything that genuinely has no home-manager equivalent (boot entries, VM
# builds) is called out in the help text instead of being faked.

HM_FLAKE_PATH="${HM_PATH:-$HOME/.config/home-manager}"
HM_FLAKE_OUTPUT="${HM_USER:-$(whoami)@$(hostname)}"
HM_PROFILE="$HOME/.local/state/nix/profiles/home-manager"

# `home-manager generations` prints, newest first:
#   2026-10-22 11:09 : id 180 -> /nix/store/xxx-home-manager-generation (current)
# Normalise that into TSV: id, date, path, is_current (1/0). Everything below
# consumes this, so the fragile text format is only parsed in one place.
gen_rows() {
  home-manager generations |
    sed -nE 's/^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}) : id ([0-9]+) -> ([^ ]+) ?(\(current\))?$/\2\t\1\t\3\t\4/p' |
    awk -F'\t' -v OFS='\t' '{ print $1, $2, $3, ($4 == "(current)" ? 1 : 0) }'
}

current_gen_id() {
  gen_rows | awk -F'\t' '$4 == 1 { print $1; exit }'
}

gen_path_for() {
  local id="$1"
  gen_rows | awk -F'\t' -v id="$id" '$1 == id { print $3; exit }'
}

contains() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    if [[ $item == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

# nixos-cli accepts systemd.time spans ("30d 2h 1m"); mirror that so the same
# `--older-than 8d` works for both tools.
parse_period() {
  local spec="$1"
  local total=0 token num unit
  for token in $spec; do
    if [[ ! $token =~ ^([0-9]+)([smhdwMy])$ ]]; then
      echo "error: invalid period \"$token\" (expected values like \"30d\", \"2h 30m\")" >&2
      return 1
    fi
    num="${BASH_REMATCH[1]}"
    unit="${BASH_REMATCH[2]}"
    case "$unit" in
      s) total=$((total + num)) ;;
      m) total=$((total + num * 60)) ;;
      h) total=$((total + num * 3600)) ;;
      d) total=$((total + num * 86400)) ;;
      w) total=$((total + num * 604800)) ;;
      M) total=$((total + num * 2592000)) ;;
      y) total=$((total + num * 31536000)) ;;
    esac
  done
  echo "$total"
}

usage() {
  cat <<EOF
A nixos-cli style front-end for home-manager.

Usage:
  hm [command]

Commands:
  apply                    Build and activate a configuration
  build                    Build a configuration into ./result
  info                     Show info about the current generation
  news                     Show unread home-manager news
  option                   Query home-manager options
  repl                     Start a Nix REPL with the configuration loaded
  generation               Manage home-manager generations

Aliases:
  switch                   Alias for \`apply\`.
  dry-activate             Alias for \`apply --dry-run\`.
  dry-build                Alias for \`build --dry-run\`.
  list-generations         Alias for \`generation list --table\`.
  test                     Alias for \`apply\` (home-manager has no boot entries).

Flags:
      --flake path         Flake to activate (default: \$HM_PATH or ~/.config/home-manager)
      --user output        Flake output to activate (default: \$HM_USER or user@host)
  -h, --help               Show this help menu
  -v, --version            Display version information

Environment Variables:
  HM_PATH                  Flake path; currently "${HM_PATH:-<not set>}"
  HM_USER                  Flake output; currently "${HM_USER:-<not set>}"

Current defaults:
  flake                    ${HM_FLAKE_PATH}#${HM_FLAKE_OUTPUT}
  profile                  ${HM_PROFILE}

Run 'hm generation --help' for generation commands.
EOF
}

generation_usage() {
  cat <<EOF
Manage home-manager generations.

Usage:
  hm generation [command]

Commands:
  delete      Delete generations from this system
  diff        Show what changed between two generations
  list        List all home-manager generations
  rollback    Activate the previous generation
  switch      Activate an existing generation

Flags:
  -h, --help    Show this help menu
EOF
}

delete_usage() {
  cat <<EOF
Delete home-manager generations and their store paths.

Usage:
  hm generation delete [flags] [GEN...]

Flags:
  -a, --all                 Delete all generations except the current one
  -h, --help                Show this help menu
  -k, --keep gen            Always keep this gen, can be specified many times
  -m, --min num             Keep a minimum of num generations
  -o, --older-than period   Delete all generations older than period
      --pattern regex       Delete all generations matching regex
  -y, --yes                 Automatically confirm generation deletion

Unlike nixos-cli this also deletes the generations' store paths, so no
separate garbage collection is needed to reclaim the space.
EOF
}

cmd_version() {
  printf 'hm (nixos-cli style wrapper for home-manager)\n'
  printf 'home-manager: %s\n' "$(home-manager --version)"
}

cmd_apply() {
  # nixos accepts -y/--yes on every mutating command; home-manager never
  # prompts, so accept and drop it to keep scripts working with either tool.
  local -a args=()
  local arg
  for arg in "$@"; do
    case "$arg" in
      -y | --yes) ;;
      *) args+=("$arg") ;;
    esac
  done
  home-manager switch --flake "$HM_FLAKE_PATH#$HM_FLAKE_OUTPUT" -b bkp "${args[@]}"
}

cmd_build() {
  home-manager build --flake "$HM_FLAKE_PATH#$HM_FLAKE_OUTPUT" "$@"
}

cmd_list() {
  local format=table
  local arg
  for arg in "$@"; do
    case "$arg" in
      -t | --table) format=table ;;
      -j | --json) format=json ;;
      -h | --help)
        generation_usage
        return 0
        ;;
      *)
        echo "error: unknown flag \"$arg\" for \"hm generation list\"" >&2
        return 1
        ;;
    esac
  done

  local rows
  rows="$(gen_rows)"
  if [[ -z $rows ]]; then
    echo "No generations found"
    return 0
  fi

  if [[ $format == json ]]; then
    local id date path current iso
    local first=1
    echo "["
    while IFS=$'\t' read -r id date path current; do
      [[ -z $id ]] && continue
      iso="$(date -d "$date" --iso-8601=seconds)"
      if ((first)); then
        first=0
      else
        echo ","
      fi
      printf '  {"path": "%s", "number": %s, "creation_date": "%s", "is_current": %s}' \
        "$path" "$id" "$iso" "$([[ $current == 1 ]] && echo true || echo false)"
    done <<<"$rows"
    echo
    echo "]"
  else
    printf 'NUMBER\tCURRENT\tDATE\tPATH\n'
    awk -F'\t' -v OFS='\t' '{ print $1, ($4 == 1 ? "true" : "false"), $2, $3 }' <<<"$rows" |
      column -t -s$'\t'
  fi
}

cmd_delete() {
  local all=0
  local older=""
  local min=0
  local pattern=""
  local assume_yes=0
  local -a keep=()
  local -a ids=()
  local arg

  while (($#)); do
    case "$1" in
      -a | --all) all=1 ;;
      -o | --older-than)
        older="${2:-}"
        shift
        ;;
      --older-than=*) older="${1#*=}" ;;
      -m | --min)
        min="${2:-}"
        shift
        ;;
      --min=*) min="${1#*=}" ;;
      -k | --keep)
        keep+=("${2:-}")
        shift
        ;;
      --keep=*) keep+=("${1#*=}") ;;
      --pattern)
        pattern="${2:-}"
        shift
        ;;
      --pattern=*) pattern="${1#*=}" ;;
      -y | --yes) assume_yes=1 ;;
      -h | --help)
        delete_usage
        return 0
        ;;
      -*)
        echo "error: unknown flag \"$1\" for \"hm generation delete\"" >&2
        return 1
        ;;
      *) ids+=("$1") ;;
    esac
    shift
  done

  if ((${#ids[@]} == 0)) && ((!all)) && [[ -z $older && -z $pattern ]]; then
    echo "error: no generations or deletion parameters were given" >&2
    return 1
  fi

  if [[ ! $min =~ ^[0-9]+$ ]]; then
    echo "error: --min expects a number, got \"$min\"" >&2
    return 1
  fi

  local id
  for id in "${ids[@]}"; do
    if [[ ! $id =~ ^[0-9]+$ ]]; then
      echo "error: generation IDs must be numbers, got \"$id\"" >&2
      return 1
    fi
  done

  local rows
  rows="$(gen_rows)"
  if [[ -z $rows ]]; then
    echo "No generations found"
    return 0
  fi

  local cutoff=""
  local secs epoch
  if [[ -n $older ]]; then
    secs="$(parse_period "$older")" || return 1
    cutoff=$(($(date +%s) - secs))
  fi

  # Select first, filter keep rules afterwards, so `--all --min 3` behaves like
  # nixos-cli: everything except the three newest generations.
  local -a selected=()
  local date path current
  while IFS=$'\t' read -r id date path current; do
    [[ -z $id ]] && continue
    if ((all)) || contains "$id" "${ids[@]}"; then
      selected+=("$id")
      continue
    fi
    if [[ -n $cutoff ]]; then
      epoch="$(date -d "$date" +%s)"
      if ((epoch < cutoff)); then
        selected+=("$id")
        continue
      fi
    fi
    if [[ -n $pattern ]] && { [[ $id =~ $pattern ]] || [[ $path =~ $pattern ]]; }; then
      selected+=("$id")
    fi
  done <<<"$rows"

  local current_gen
  current_gen="$(current_gen_id)"

  local -a doomed=()
  local rank=0
  while IFS=$'\t' read -r id date path current; do
    [[ -z $id ]] && continue
    rank=$((rank + 1))
    contains "$id" "${selected[@]}" || continue
    [[ $id == "$current_gen" ]] && continue
    contains "$id" "${keep[@]}" && continue
    # Keep the newest N generations, matching `--min` semantics.
    ((rank <= min)) && continue
    doomed+=("$id")
  done <<<"$rows"

  if ((${#doomed[@]} == 0)); then
    echo "No generations to delete"
    return 0
  fi

  echo "The following generations will be deleted:"
  for id in "${doomed[@]}"; do
    printf '  id %s -> %s\n' "$id" "$(gen_path_for "$id")"
  done

  if ((!assume_yes)); then
    if [[ ! -t 0 ]]; then
      echo "error: refusing to delete without confirmation (use -y)" >&2
      return 1
    fi
    local reply
    read -r -p "Delete these ${#doomed[@]} generation(s)? [y/N] " reply
    if [[ $reply != [yY]* ]]; then
      echo "Aborted."
      return 1
    fi
  fi

  # Capture paths before the links are gone, then delete links, then paths.
  # `nix store delete` refuses to remove paths that are still referenced, which
  # is exactly the safety net we want for generations sharing a closure.
  local -A paths=()
  for id in "${doomed[@]}"; do
    paths[$id]="$(gen_path_for "$id")"
  done

  home-manager remove-generations "${doomed[@]}"

  for id in "${doomed[@]}"; do
    path="${paths[$id]}"
    [[ -z $path ]] && continue
    # Paths shared with a kept generation stay alive; nix-collect-garbage
    # reclaims them once nothing references them any more.
    if ! nix store delete "$path" >/dev/null 2>&1; then
      echo "warning: kept $path in the store (still referenced)" >&2
    fi
  done
}

activate_generation() {
  local gen="$1"
  local dry="$2"
  local path
  path="$(gen_path_for "$gen")"
  if [[ -z $path ]]; then
    echo "error: generation $gen does not exist" >&2
    return 1
  fi
  if ((dry)); then
    echo "Would activate generation $gen: $path"
    return 0
  fi
  home-manager switch --flake "$HM_FLAKE_PATH" --switch-generation "$gen" -b bkp
}

cmd_rollback() {
  local dry=0
  local arg
  for arg in "$@"; do
    case "$arg" in
      -d | --dry) dry=1 ;;
      -y | --yes) : ;;
      -h | --help)
        generation_usage
        return 0
        ;;
      *)
        echo "error: unknown flag \"$arg\" for \"hm generation rollback\"" >&2
        return 1
        ;;
    esac
  done

  local current_gen previous
  current_gen="$(current_gen_id)"
  if [[ -z $current_gen ]]; then
    echo "error: could not determine the current generation" >&2
    return 1
  fi

  previous="$(gen_rows | awk -F'\t' -v cur="$current_gen" 'seen { print $1; exit } $1 == cur { seen = 1 }')"
  if [[ -z $previous ]]; then
    echo "error: no previous generation to roll back to" >&2
    return 1
  fi

  activate_generation "$previous" "$dry"
}

cmd_switch_generation() {
  local dry=0
  local gen=""
  local arg
  for arg in "$@"; do
    case "$arg" in
      -d | --dry) dry=1 ;;
      -y | --yes) : ;;
      -h | --help)
        generation_usage
        return 0
        ;;
      -*)
        echo "error: unknown flag \"$arg\" for \"hm generation switch\"" >&2
        return 1
        ;;
      *)
        if [[ -n $gen ]]; then
          echo "error: switch accepts exactly one generation ID" >&2
          return 1
        fi
        gen="$arg"
        ;;
    esac
  done

  if [[ -z $gen ]]; then
    echo "error: switch requires a generation ID" >&2
    return 1
  fi
  if [[ ! $gen =~ ^[0-9]+$ ]]; then
    echo "error: generation IDs must be numbers, got \"$gen\"" >&2
    return 1
  fi

  activate_generation "$gen" "$dry"
}

cmd_diff() {
  local -a gens=()
  local arg
  for arg in "$@"; do
    case "$arg" in
      -h | --help)
        generation_usage
        return 0
        ;;
      -*)
        echo "error: unknown flag \"$arg\" for \"hm generation diff\"" >&2
        return 1
        ;;
      *) gens+=("$arg") ;;
    esac
  done

  if ((${#gens[@]} != 2)); then
    echo "usage: hm generation diff {BEFORE} {AFTER}" >&2
    return 1
  fi

  local before after
  before="$(gen_path_for "${gens[0]}")"
  after="$(gen_path_for "${gens[1]}")"
  if [[ -z $before ]]; then
    echo "error: generation ${gens[0]} does not exist" >&2
    return 1
  fi
  if [[ -z $after ]]; then
    echo "error: generation ${gens[1]} does not exist" >&2
    return 1
  fi

  nix store diff-closures "$before" "$after"
}

cmd_info() {
  local current_gen
  current_gen="$(current_gen_id)"
  if [[ -z $current_gen ]]; then
    echo "error: no current generation found" >&2
    return 1
  fi

  local id date path current
  IFS=$'\t' read -r id date path current < <(
    gen_rows | awk -F'\t' -v cur="$current_gen" '$1 == cur'
  )

  printf 'Home Manager\n'
  printf -- '------------\n'
  printf 'Generation :: %s\n' "$id"
  printf 'Date       :: %s\n' "$date"
  printf 'Path       :: %s\n' "$path"
  printf 'Flake      :: %s#%s\n' "$HM_FLAKE_PATH" "$HM_FLAKE_OUTPUT"
  printf 'Profile    :: %s\n' "$HM_PROFILE"
}

cmd_option() {
  # home-manager refuses to inspect options of a flake configuration
  # ("Can't inspect options of a flake configuration"), so evaluate the flake
  # output directly instead of shelling out to `home-manager option`.
  local recursive=0
  local -a names=()
  local arg
  for arg in "$@"; do
    case "$arg" in
      -r | --recursive) recursive=1 ;;
      -h | --help)
        usage
        return 0
        ;;
      -*)
        echo "error: unknown flag \"$arg\" for \"hm option\"" >&2
        return 1
        ;;
      *) names+=("$arg") ;;
    esac
  done

  if ((${#names[@]} != 1)); then
    echo "usage: hm option [--recursive] OPTION.NAME" >&2
    return 1
  fi

  local ref="$HM_FLAKE_PATH#homeConfigurations.\"$HM_FLAKE_OUTPUT\".config"
  if ((recursive)); then
    nix eval --json "$ref.${names[0]}"
  elif ! nix eval --raw "$ref.${names[0]}" 2>/dev/null; then
    # Not a string-like value: fall back to the normal (quoted) rendering.
    nix eval "$ref.${names[0]}"
  else
    # --raw omits the trailing newline.
    printf '\n'
  fi
}

cmd_generation() {
  local sub="${1:-}"
  if [[ -z $sub || $sub == -h || $sub == --help ]]; then
    generation_usage
    return 0
  fi
  shift

  case "$sub" in
    list) cmd_list "$@" ;;
    delete) cmd_delete "$@" ;;
    rollback) cmd_rollback "$@" ;;
    switch) cmd_switch_generation "$@" ;;
    diff) cmd_diff "$@" ;;
    *)
      echo "error: unknown command \"$sub\" for \"hm generation\"" >&2
      echo "Run 'hm generation --help' for usage." >&2
      return 1
      ;;
  esac
}

main() {
  while (($#)); do
    case "$1" in
      -h | --help)
        usage
        return 0
        ;;
      -v | --version)
        cmd_version
        return 0
        ;;
      --flake)
        HM_FLAKE_PATH="${2:?--flake requires a path}"
        shift 2
        ;;
      --flake=*)
        HM_FLAKE_PATH="${1#*=}"
        shift
        ;;
      --user)
        HM_FLAKE_OUTPUT="${2:?--user requires a value}"
        shift 2
        ;;
      --user=*)
        HM_FLAKE_OUTPUT="${1#*=}"
        shift
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "error: unknown flag \"$1\" for \"hm\"" >&2
        echo "Run 'hm --help' for usage." >&2
        return 1
        ;;
      *) break ;;
    esac
  done

  local cmd="${1:-}"
  if [[ -z $cmd ]]; then
    usage
    return 0
  fi
  shift

  case "$cmd" in
    apply | switch) cmd_apply "$@" ;;
    build) cmd_build "$@" ;;
    dry-activate) cmd_apply -n "$@" ;;
    dry-build) cmd_build -n "$@" ;;
    test) cmd_apply "$@" ;;
    info) cmd_info ;;
    news) home-manager news ;;
    option) cmd_option "$@" ;;
    repl) home-manager repl --flake "$HM_FLAKE_PATH#$HM_FLAKE_OUTPUT" "$@" ;;
    generation) cmd_generation "$@" ;;
    list-generations) cmd_list --table "$@" ;;
    help) usage ;;
    *)
      echo "error: unknown command \"$cmd\" for \"hm\"" >&2
      echo "Run 'hm --help' for usage." >&2
      return 1
      ;;
  esac
}

main "$@"
