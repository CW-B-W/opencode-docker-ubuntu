#!/bin/bash
set -e

PROJECT_ROOT="$(dirname "$(dirname "$0")")"
PERSISTENT_ROOT="$PROJECT_ROOT/persistent_root"

mkdir -p "$PERSISTENT_ROOT/root/.config/opencode"
mkdir -p "$PERSISTENT_ROOT/root/.local/share/opencode"

if [ ! -e "$PROJECT_ROOT/opencode.json" ]; then
    ln -s "$PERSISTENT_ROOT/root/.config/opencode/opencode.json" "$PROJECT_ROOT/opencode.json"
    echo "opencode.json -> persistent_root/root/.config/opencode/opencode.json"
fi

if [ ! -e "$PROJECT_ROOT/auth.json" ]; then
    ln -s "$PERSISTENT_ROOT/root/.local/share/opencode/auth.json" "$PROJECT_ROOT/auth.json"
    echo "auth.json -> persistent_root/root/.local/share/opencode/auth.json"
fi

echo "Done! Next: cp .env.example .env && docker compose up -d"
