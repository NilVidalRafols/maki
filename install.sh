#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.local/bin"
GITHUB_RAW="https://raw.githubusercontent.com/NilVidalRafols/maki/main"

echo "Installing maki to $INSTALL_DIR..."

mkdir -p "$INSTALL_DIR"

curl -fsSL "$GITHUB_RAW/maki.sh" -o "$INSTALL_DIR/maki"
chmod +x "$INSTALL_DIR/maki"
ln -sf "$INSTALL_DIR/maki" "$INSTALL_DIR/m"

curl -fsSL "$GITHUB_RAW/mllm.sh" -o "$INSTALL_DIR/mllm"
chmod +x "$INSTALL_DIR/mllm"

curl -fsSL "$GITHUB_RAW/mmap.sh" -o "$INSTALL_DIR/mmap"
chmod +x "$INSTALL_DIR/mmap"

curl -fsSL "$GITHUB_RAW/mpmap.sh" -o "$INSTALL_DIR/mpmap"
chmod +x "$INSTALL_DIR/mpmap"

echo "Installation complete!"
echo "You can run maki as maki or m. Maki's subcommands llm, map and pmap (parallel map) can also be directly executed as mllm, mmap and mpmap respectively."
echo "If you are not able to run maki commands make sure that $INSTALL_DIR is present in your PATH variable"

