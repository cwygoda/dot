#!/bin/bash

set -e

SRC_DIR="$(cd "$(dirname "$0")/src" && pwd)"
HOME_DIR="$HOME"

find "$SRC_DIR" -type f | while read -r src_file; do
    # Get relative path from src directory
    rel_path="${src_file#$SRC_DIR/}"
    target_path="$HOME_DIR/$rel_path"

    if [[ -e "$target_path" ]]; then
        echo "[INFO] File already exists: $target_path"
    else
        # Create parent directory if needed
        mkdir -p "$(dirname "$target_path")"
        ln -s "$src_file" "$target_path"
        echo "[LINK] Created symlink: $target_path -> $src_file"
    fi
done
