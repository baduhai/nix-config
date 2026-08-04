{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages.arc = pkgs.writeShellApplication {
        name = "arc";
        runtimeInputs = with pkgs; [
          gnutar
          gzip
          bzip2
          xz
          zstd
          lz4
          lzip
          zip
          unzip
          p7zip
          rar
          unrar
          binutils
        ];
        text = ''
          set -euo pipefail

          show_help() {
            cat <<'HELP'
          Usage: arc [options] <files...> <archive.ext>
                 arc [options] -x|--extract <archive.ext> [target-dir]

          Options:
            -h, --help     Show this help message
            -v, --verbose  Enable verbose output
            -x, --extract  Extract an archive

          Archive formats (detected by extension):
            .tar.gz, .tgz        .tar.bz2, .tbz2      .tar.xz, .txz
            .tar.zst             .tar.lz4              .tar.lz, .tar.lzip
            .tar                 .gz                   .bz2
            .xz                  .zst                  .lz4
            .zip                 .7z                   .rar
            .ar

          Extraction:
            With no target dir, archives are extracted to a directory named
            after the archive. If the archive already contains a single
            top-level directory matching that name, extraction is done in
            the current directory to avoid nesting.
            Single-file compressors (.gz, .bz2, etc.) decompress in place.
          HELP
          }

          get_format() {
            case "$1" in
              *.tar.lzip) echo "tar.lz" ;;
              *.tar.lz)   echo "tar.lz" ;;
              *.tar.zst)  echo "tar.zst" ;;
              *.tar.lz4)  echo "tar.lz4" ;;
              *.tar.gz)   echo "tar.gz" ;;
              *.tar.bz2)  echo "tar.bz2" ;;
              *.tar.xz)   echo "tar.xz" ;;
              *.tgz)      echo "tar.gz" ;;
              *.tbz2)     echo "tar.bz2" ;;
              *.txz)      echo "tar.xz" ;;
              *.tar)      echo "tar" ;;
              *.gz)       echo "gz" ;;
              *.bz2)      echo "bz2" ;;
              *.xz)       echo "xz" ;;
              *.zst)      echo "zst" ;;
              *.lz4)      echo "lz4" ;;
              *.zip)      echo "zip" ;;
              *.7z)       echo "7z" ;;
              *.rar)      echo "rar" ;;
              *.ar)       echo "ar" ;;
              *)          echo "" ;;
            esac
          }

          get_basename() {
            local name="''${1##*/}"
            name="''${name%.tar.lzip}"
            name="''${name%.tar.lz}"
            name="''${name%.tar.zst}"
            name="''${name%.tar.lz4}"
            name="''${name%.tar.gz}"
            name="''${name%.tar.bz2}"
            name="''${name%.tar.xz}"
            name="''${name%.tgz}"
            name="''${name%.tbz2}"
            name="''${name%.txz}"
            name="''${name%.tar}"
            name="''${name%.gz}"
            name="''${name%.bz2}"
            name="''${name%.xz}"
            name="''${name%.zst}"
            name="''${name%.lz4}"
            name="''${name%.zip}"
            name="''${name%.7z}"
            name="''${name%.rar}"
            name="''${name%.ar}"
            printf '%s\n' "$name"
          }

          has_top_dir() {
            local file="$1" dirname="$2"
            local fmt listing
            fmt=$(get_format "$file")

            case "$fmt" in
              tar.gz|tar.bz2|tar.xz|tar.zst|tar.lz4|tar.lz|tar)
                listing=$(tar -tf "$file" 2>/dev/null | cut -d/ -f1 | sort -u) || return 1
                ;;
              zip)
                listing=$(unzip -l "$file" 2>/dev/null | awk '
                  BEGIN { in_body = 0 }
                  /^---/ { in_body = !in_body; next }
                  in_body && NF > 0 { print $NF }
                ' | cut -d/ -f1 | sort -u) || return 1
                ;;
              7z)
                listing=$(7z l -ba -slt "$file" 2>/dev/null | grep '^Path = ' | sed 's/^Path = //' | cut -d/ -f1 | sort -u) || return 1
                ;;
              rar)
                listing=$(unrar vb "$file" 2>/dev/null | cut -d/ -f1 | sort -u) || return 1
                ;;
              *)
                return 1
                ;;
            esac

            [[ -n "$listing" && "$listing" == "$dirname" ]] && return 0
            return 1
          }

          create_archive() {
            local format="$1" out="$2"
            shift 2
            local files=("$@")

            case "$format" in
              tar.gz)
                tar "''${vflag}"czf "$out" "''${files[@]}"
                ;;
              tar.bz2)
                tar "''${vflag}"cjf "$out" "''${files[@]}"
                ;;
              tar.xz)
                tar "''${vflag}"cJf "$out" "''${files[@]}"
                ;;
              tar.zst)
                tar --use-compress-program=zstd "''${vflag}"cf "$out" "''${files[@]}"
                ;;
              tar.lz4)
                tar --use-compress-program=lz4 "''${vflag}"cf "$out" "''${files[@]}"
                ;;
              tar.lz)
                tar --lzip "''${vflag}"cf "$out" "''${files[@]}"
                ;;
              tar)
                tar "''${vflag}"cf "$out" "''${files[@]}"
                ;;
              gz|bz2|xz|zst|lz4)
                if [[ ''${#files[@]} -ne 1 ]]; then
                  echo "Error: .$format compresses a single file only, got ''${#files[@]}" >&2
                  return 1
                fi
                case "$format" in
                  gz)  gzip -c < "''${files[0]}" > "$out" ;;
                  bz2) bzip2 -c < "''${files[0]}" > "$out" ;;
                  xz)  xz -c < "''${files[0]}" > "$out" ;;
                  zst) zstd -q -c < "''${files[0]}" > "$out" ;;
                  lz4) lz4 -q -c < "''${files[0]}" > "$out" ;;
                esac
                ;;
              zip)
                if [[ -n "$vflag" ]]; then
                  zip -v "$out" "''${files[@]}"
                else
                  zip -q "$out" "''${files[@]}"
                fi
                ;;
              7z)
                7z a "$out" "''${files[@]}"
                ;;
              rar)
                rar a "$out" "''${files[@]}"
                ;;
              ar)
                ar rcs "$out" "''${files[@]}"
                ;;
            esac
          }

          extract_archive() {
            local format="$1" file="$2" dest="$3" vflag="$4"

            case "$format" in
              tar.gz)
                tar "''${vflag}"xzf "$file" -C "$dest"
                ;;
              tar.bz2)
                tar "''${vflag}"xjf "$file" -C "$dest"
                ;;
              tar.xz)
                tar "''${vflag}"xJf "$file" -C "$dest"
                ;;
              tar.zst)
                tar --use-compress-program=unzstd "''${vflag}"xf "$file" -C "$dest"
                ;;
              tar.lz4)
                tar --use-compress-program=unlz4 "''${vflag}"xf "$file" -C "$dest"
                ;;
              tar.lz)
                tar --lzip "''${vflag}"xf "$file" -C "$dest"
                ;;
              tar)
                tar "''${vflag}"xf "$file" -C "$dest"
                ;;
              gz)
                gunzip -c "$file" > "$dest/$(basename "$file" .gz)"
                ;;
              bz2)
                bunzip2 -c "$file" > "$dest/$(basename "$file" .bz2)"
                ;;
              xz)
                unxz -c "$file" > "$dest/$(basename "$file" .xz)"
                ;;
              zst)
                unzstd -q -c "$file" > "$dest/$(basename "$file" .zst)"
                ;;
              lz4)
                unlz4 -q -c "$file" > "$dest/$(basename "$file" .lz4)"
                ;;
              zip)
                if [[ -n "$vflag" ]]; then
                  unzip "$file" -d "$dest"
                else
                  unzip -q "$file" -d "$dest"
                fi
                ;;
              7z)
                7z x "$file" -o"$dest"
                ;;
              rar)
                unrar x "$file" "$dest/"
                ;;
              ar)
                (
                  cd "$dest"
                  ar x "$(realpath "$file")"
                )
                ;;
            esac
          }

          # ── main ──────────────────────────────────────────────

          vflag=""
          extract=false
          positional=()

          while [[ $# -gt 0 ]]; do
            case "$1" in
              -h|--help)
                show_help
                exit 0
                ;;
              -v|--verbose)
                vflag="v"
                shift
                ;;
              -x|--extract)
                extract=true
                shift
                ;;
              -*)
                echo "Error: unknown option '$1'" >&2
                show_help >&2
                exit 1
                ;;
              *)
                positional+=("$1")
                shift
                ;;
            esac
          done

          # Consume any remaining positional args after -x
          while [[ $# -gt 0 ]]; do
            positional+=("$1")
            shift
          done

          set -- "''${positional[@]}"

          if $extract; then
            if [[ $# -lt 1 ]]; then
              echo "Error: no archive specified for extraction" >&2
              exit 1
            fi

            file="$1"
            if [[ ! -f "$file" ]]; then
              echo "Error: '$file' is not a valid file" >&2
              exit 1
            fi

            format=$(get_format "$file")
            if [[ -z "$format" ]]; then
              echo "Error: unsupported archive type for '$file'" >&2
              exit 1
            fi

            if [[ $# -ge 2 ]]; then
              dest="$2"
              mkdir -p "$dest" || { echo "Error: failed to create directory '$dest'" >&2; exit 1; }
            else
              case "$format" in
                gz|bz2|xz|zst|lz4)
                  dest="."
                  ;;
                *)
                  basename=$(get_basename "$file")
                  if [[ -z "$basename" ]]; then
                    echo "Error: could not determine basename for '$file'" >&2
                    exit 1
                  fi
                  if has_top_dir "$file" "$basename"; then
                    dest="."
                  else
                    dest="$basename"
                    mkdir -p "$dest" || { echo "Error: failed to create directory '$dest'" >&2; exit 1; }
                  fi
                  ;;
              esac
            fi

            extract_archive "$format" "$file" "$dest" "$vflag"

          else
            if [[ $# -lt 2 ]]; then
              echo "Error: expected at least one source file and an archive name" >&2
              echo "Usage: arc [options] <files...> <archive.ext>" >&2
              exit 1
            fi

            out=''${!#}
            files=("''${@:1:$#-1}")

            for f in "''${files[@]}"; do
              if [[ ! -e "$f" ]]; then
                echo "Error: '$f' does not exist" >&2
                exit 1
              fi
            done

            format=$(get_format "$out")
            if [[ -z "$format" ]]; then
              echo "Error: unsupported archive type for '$out'" >&2
              exit 1
            fi

            create_archive "$format" "$out" "''${files[@]}"
          fi
        '';
      };
    };
}
