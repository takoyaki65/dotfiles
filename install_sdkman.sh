#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

info "Installing SDKMAN..."

if [ -d "$HOME/.sdkman" ]; then
    warn "SDKMAN is already installed"
    read -p "Reinstall? [y/N] " response
    if [[ ! "$response" =~ ^[yY]$ ]]; then
        info "Skipped."
        exit 0
    fi
    rm -rf "$HOME/.sdkman"
fi

# Install SDKMAN
curl -s "https://get.sdkman.io" | bash

# Load SDKMAN
source "$HOME/.sdkman/bin/sdkman-init.sh"

info "SDKMAN installed: $(sdk version)"
info "Restart your shell or run 'source \"\$HOME/.sdkman/bin/sdkman-init.sh\"'."
