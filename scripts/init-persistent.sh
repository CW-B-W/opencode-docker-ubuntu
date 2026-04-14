#!/bin/bash
set -e

IMAGE_NAME="${1:-opencode-docker-ubuntu}"
PERSISTENT_ROOT="$(dirname "$0")/../persistent_root"

DIRS="etc home media mnt opt root run srv usr var"

echo "OpenCode Docker - Initial Setup"
echo "Image: $IMAGE_NAME"
echo "Target: $PERSISTENT_ROOT"
echo ""

if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    echo "Error: Image '$IMAGE_NAME' not found."
    echo "Build first: docker build -t $IMAGE_NAME ."
    exit 1
fi

echo "[1/3] Creating directory structure..."
mkdir -p "$PERSISTENT_ROOT"
mkdir -p "$PERSISTENT_ROOT/root/.config/opencode"
mkdir -p "$PERSISTENT_ROOT/root/.local/share/opencode"

echo "[2/3] Extracting directories..."
for dir in $DIRS; do
    mkdir -p "$PERSISTENT_ROOT/$dir"
    docker run --rm \
        --entrypoint sh \
        -v "$(pwd)/persistent_root/$dir:/target" \
        "$IMAGE_NAME" \
        -c "tar -C /$dir -cf - . 2>/dev/null | tar -xf - -C /target 2>/dev/null || true"
done

echo "[3/3] Creating system symlinks..."
cd "$PERSISTENT_ROOT"
[ ! -e bin ] && ln -s usr/bin bin
[ ! -e lib ] && ln -s usr/lib lib
[ ! -e lib64 ] && ln -s usr/lib64 lib64
[ ! -e sbin ] && ln -s usr/sbin sbin
cd - > /dev/null

echo ""
echo "Done! Next: ./scripts/create-symlinks.sh"
