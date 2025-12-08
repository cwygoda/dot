#!/bin/bash

set -e

FORCE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            FORCE=true
            shift
            ;;
        *)
            echo "Usage: $0 [-f|--force]"
            exit 1
            ;;
    esac
done

SRC_DIR="$(cd "$(dirname "$0")/src" && pwd)"
HOME_DIR="$HOME"

find "$SRC_DIR" -type f | while read -r src_file; do
    # Get relative path from src directory
    rel_path="${src_file#$SRC_DIR/}"
    target_path="$HOME_DIR/$rel_path"

    if [[ -e "$target_path" ]] && [[ "$FORCE" == false ]]; then
        echo "[SKIP] File already exists: $target_path"
    elif [[ -e "$target_path" ]] && [[ "$FORCE" == true ]]; then
        rm -f "$target_path"
        mkdir -p "$(dirname "$target_path")"
        ln -s "$src_file" "$target_path"
        echo "[REPLACE] Replaced: $target_path -> $src_file"
    else
        # Create parent directory if needed
        mkdir -p "$(dirname "$target_path")"
        ln -s "$src_file" "$target_path"
        echo "[LINK] Created symlink: $target_path -> $src_file"
    fi
done
