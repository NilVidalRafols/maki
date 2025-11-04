#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.local/bin"

echo "Uninstalling maki from $INSTALL_DIR..."

rm -f "$INSTALL_DIR/maki"

rm -f "$INSTALL_DIR/m"

rm -f "$INSTALL_DIR/mllm"

rm -f "$INSTALL_DIR/mmap"

rm -f "$INSTALL_DIR/mpmap"

echo "Uninstallation complete!"

