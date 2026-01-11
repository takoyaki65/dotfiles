#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

info "Installing Rust via rustup..."

if command -v rustc &> /dev/null; then
    warn "Rust is already installed: $(rustc --version)"
    read -p "Reinstall? [y/N] " response
    if [[ ! "$response" =~ ^[yY]$ ]]; then
        info "Skipped."
        exit 0
    fi
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

info "Rust installed: $(rustc --version)"
info "Run 'source ~/.cargo/env' or restart your shell."
