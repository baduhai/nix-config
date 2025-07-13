{ lib
, stdenv
, nixos-rebuild
, openssh
, coreutils
, gnugrep
, gawk
}:

stdenv.mkDerivation rec {
  pname = "nixos-deploy";
  version = "1.0";

  src = lib.fakeSha256; # will be ignored since we're using `installPhase`

  dontUnpack = true;

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/nixos-deploy << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

LOCAL_BUILD=false
ACTION="switch"
FLAKE_URI=""
TARGET_HOST=""
SSH_USER=""
SSH_HOST=""

show_usage() {
    echo -e "Usage: nixos-deploy [--local-build] [--boot] <flake-uri> [user@]host"
    echo ""
    echo -e "Arguments:"
    echo "  flake-uri    Flake URI (e.g., .#hostname)"
    echo "  [user@]host  Target host, optionally with user"
    echo ""
    echo -e "Options:"
    echo "  --local-build  Build locally instead of on remote"
    echo "  --boot         Use 'boot' instead of 'switch' action"
    echo ""
    echo -e "Examples:"
    echo "  nixos-deploy .#hostname user@192.168.1.10"
    echo "  nixos-deploy --local-build .#hostname 192.168.1.10"
    echo "  nixos-deploy --boot .#hostname 192.168.1.10"
    echo "  nixos-deploy .#hostname 192.168.1.10  # uses current user"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --local-build)
            LOCAL_BUILD=true
            shift
            ;;
        --boot)
            ACTION="boot"
            shift
            ;;
        --help|-h)
            show_usage
            ;;
        -*)
            echo -e "Unknown option: $1"
            show_usage
            ;;
        *)
            if [[ -z "$FLAKE_URI" ]]; then
                FLAKE_URI="$1"
            elif [[ -z "$TARGET_HOST" ]]; then
                TARGET_HOST="$1"
            else
                echo -e "Too many arguments"
                show_usage
            fi
            shift
            ;;
    esac
done

if [[ -z "$FLAKE_URI" ]]; then
    echo -e "flake-uri is required"
    show_usage
fi

if [[ -z "$TARGET_HOST" ]]; then
    echo -e "target host is required"
    show_usage
fi

if [[ "$TARGET_HOST" == *"@"* ]]; then
    SSH_USER="${TARGET_HOST%@*}"
    SSH_HOST="${TARGET_HOST#*@}"
else
    SSH_USER="$("${coreutils}/bin/whoami")"
    SSH_HOST="$TARGET_HOST"
fi

echo "Deploying $FLAKE_URI to $SSH_HOST as user $SSH_USER (action: $ACTION)"

if [[ "$LOCAL_BUILD" != "true" ]]; then
    GC_ROOT_PATH="/tmp/nixos-deploy-$SSH_HOST-$$"
fi

REBUILD_CMD="${nixos-rebuild}/bin/nixos-rebuild $ACTION --flake $FLAKE_URI --target-host $TARGET_HOST"

if [[ "$LOCAL_BUILD" == "true" ]]; then
    echo -e "Building locally and deploying to remote host"
else
    REBUILD_CMD="$REBUILD_CMD --build-host $SSH_HOST"
    echo -e "Building on remote host"
fi

if [[ "$SSH_USER" != "root" ]]; then
    REBUILD_CMD="$REBUILD_CMD --use-remote-sudo"
    echo -e "Using remote sudo for non-root user"
fi

echo -e "Running: $REBUILD_CMD"
exec $REBUILD_CMD
EOF
    chmod +x $out/bin/nixos-deploy
  '';

  meta = with lib; {
    description = "Tool to deploy a NixOS flake to a remote host using nixos-rebuild";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}

