#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

NVM_VERSION="v0.40.3"

info "Installing nvm $NVM_VERSION..."

if [ -d "$HOME/.nvm" ]; then
    warn "nvm is already installed"
    read -p "Reinstall? [y/N] " response
    if [[ ! "$response" =~ ^[yY]$ ]]; then
        info "Skipped."
        exit 0
    fi
fi

# Install nvm
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

info "Installing Node.js LTS..."
nvm install --lts

info "nvm installed: $(nvm --version)"
info "Node.js installed: $(node --version)"
info "npm installed: $(npm --version)"
info "Restart your shell or run 'source ~/.bashrc'."
