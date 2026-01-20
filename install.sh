#!/bin/bash

set -e

FORCE=false
INTERACTIVE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            FORCE=true
            shift
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        *)
            echo "Usage: $0 [-f|--force] [-i|--interactive]"
            exit 1
            ;;
    esac
done

show_diff() {
    local existing="$1"
    local new="$2"
    if command -v delta &>/dev/null; then
        delta "$existing" "$new"
    else
        diff -u "$existing" "$new" || true
    fi
}

prompt_overwrite() {
    local target="$1"
    while true; do
        read -rp "Overwrite $target? [y/n]: " answer
        case "$answer" in
            [Yy]) return 0 ;;
            [Nn]) return 1 ;;
            *) echo "Please answer y or n" ;;
        esac
    done
}

SRC_DIR="$(cd "$(dirname "$0")/src" && pwd)"
HOME_DIR="$HOME"

find "$SRC_DIR" -type f | while read -r src_file; do
    # Get relative path from src directory
    rel_path="${src_file#$SRC_DIR/}"
    target_path="$HOME_DIR/$rel_path"

    if [[ -e "$target_path" ]]; then
        if [[ "$FORCE" == true ]]; then
            rm -f "$target_path"
            mkdir -p "$(dirname "$target_path")"
            ln -s "$src_file" "$target_path"
            echo "[REPLACE] Replaced: $target_path -> $src_file"
        elif [[ "$INTERACTIVE" == true ]]; then
            # Already correct symlink?
            if [[ -L "$target_path" ]] && [[ "$(readlink "$target_path")" == "$src_file" ]]; then
                echo "[OK] Already linked: $target_path"
            # Content identical? Just replace with symlink
            elif diff -q "$target_path" "$src_file" &>/dev/null; then
                rm -f "$target_path"
                mkdir -p "$(dirname "$target_path")"
                ln -s "$src_file" "$target_path"
                echo "[LINK] Replaced (identical): $target_path -> $src_file"
            else
                # Content differs - prompt
                echo ""
                echo "[CONFLICT] File differs: $target_path"
                show_diff "$target_path" "$src_file"
                if prompt_overwrite "$target_path"; then
                    rm -f "$target_path"
                    mkdir -p "$(dirname "$target_path")"
                    ln -s "$src_file" "$target_path"
                    echo "[REPLACE] Replaced: $target_path -> $src_file"
                else
                    echo "[SKIP] Kept existing: $target_path"
                fi
            fi
        else
            echo "[SKIP] File already exists: $target_path"
        fi
    else
        # Create parent directory if needed
        mkdir -p "$(dirname "$target_path")"
        ln -s "$src_file" "$target_path"
        echo "[LINK] Created symlink: $target_path -> $src_file"
    fi
done

# Setup local gitconfig if missing
GITCONFIG_LOCAL="$HOME/.gitconfig.local"
if [[ ! -e "$GITCONFIG_LOCAL" ]]; then
    echo ""
    echo "[SETUP] Creating $GITCONFIG_LOCAL"
    read -rp "Enter git user.email: " git_email
    cat > "$GITCONFIG_LOCAL" << EOF
[user]
    email = $git_email
EOF
    echo "[CREATED] $GITCONFIG_LOCAL"
fi
