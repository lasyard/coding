#!/usr/bin/env bash

set -euo pipefail

info() { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
err() { printf '[ERROR] %s\n' "$*" >&2; }

usage() {
    cat <<'EOF'
Usage:
  reduce_io.sh <mounted_volume_path> [mounted_volume_path ...]

Examples:
  reduce_io.sh /Volumes/LAS_2T
  reduce_io.sh /Volumes/LAS_2T /Volumes/LAS_1T
EOF
}

require_cmd() {
    local cmd
    for cmd in mdutil tmutil mount awk sudo touch mkdir uname; do
        command -v "$cmd" >/dev/null 2>&1 || {
            err "missing command: $cmd"
            exit 1
        }
    done
}

is_mounted_path() {
    local path=$1
    mount | awk -v target="$path" '$0 ~ " on " target " " { found=1 } END { exit(found?0:1) }'
}

validate_volume_path() {
    local path=$1

    [[ -d "$path" ]] || {
        err "path does not exist or is not a directory: $path"
        return 1
    }

    [[ "$path" = /* ]] || {
        err "path must be absolute: $path"
        return 1
    }

    case "$path" in
    / | /System | /System/* | /private | /private/* | /Users | /Users/*)
        err "refuse to operate on system path: $path"
        return 1
        ;;
    esac

    is_mounted_path "$path" || {
        err "path is not a mounted volume: $path"
        return 1
    }
}

process_volume() {
    local path=$1

    info "processing volume: $path"

    if [[ "$path" != /Volumes/* ]]; then
        warn "volume path is not under /Volumes: $path"
    fi

    info "disable Spotlight indexing"
    sudo mdutil -i off -d "$path"

    info "remove Spotlight index store"
    sudo mdutil -X "$path"

    info "create no-index marker"
    sudo touch "$path/.metadata_never_index"

    info "disable fseventsd logging"
    sudo mkdir -p "$path/.fseventsd"
    sudo touch "$path/.fseventsd/no_log"

    info "exclude from Time Machine"
    sudo tmutil addexclusion -v "$path"

    info "clean up dot files"
    dot_clean "$path"

    info "done for: $path"
}

main() {
    local path

    [[ "$(uname -s)" == "Darwin" ]] || {
        err "this script is for macOS only"
        exit 1
    }

    [[ $# -ge 1 ]] || {
        usage
        exit 1
    }

    require_cmd

    for path in "$@"; do
        validate_volume_path "$path"
    done

    info "requesting sudo permission"
    sudo -v

    for path in "$@"; do
        process_volume "$path"
    done

    info "all done"
    info "verify status with:"
    info "  mdutil -s /Volumes/YourDisk"
    info "  tmutil isexcluded /Volumes/YourDisk"
}

main "$@"
