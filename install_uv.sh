#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

info "Installing uv..."

if command -v uv &> /dev/null; then
    warn "uv is already installed: $(uv --version)"
    read -p "Reinstall? [y/N] " response
    if [[ ! "$response" =~ ^[yY]$ ]]; then
        info "Skipped."
        exit 0
    fi
fi

curl -LsSf https://astral.sh/uv/install.sh | sh

# Source cargo env where uv is installed
if [ -f "$HOME/.local/bin/uv" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

info "uv installed: $(uv --version)"
info "Restart your shell or run 'source ~/.bashrc'."
