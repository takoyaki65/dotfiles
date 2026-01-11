#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

GO_VERSION="1.25.5"
GO_INSTALL_DIR="$HOME/.local/go"

info "Installing Go $GO_VERSION..."

if command -v go &> /dev/null; then
    warn "Go is already installed: $(go version)"
    read -p "Reinstall? [y/N] " response
    if [[ ! "$response" =~ ^[yY]$ ]]; then
        info "Skipped."
        exit 0
    fi
fi

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64) GOARCH="amd64" ;;
    aarch64|arm64) GOARCH="arm64" ;;
    *) error "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Detect OS
case "$OSTYPE" in
    linux-gnu*) GOOS="linux" ;;
    darwin*) GOOS="darwin" ;;
    *) error "Unsupported OS: $OSTYPE"; exit 1 ;;
esac

TARBALL="go${GO_VERSION}.${GOOS}-${GOARCH}.tar.gz"
DOWNLOAD_URL="https://go.dev/dl/${TARBALL}"

info "Downloading $TARBALL..."
curl -LO "$DOWNLOAD_URL"

info "Installing to $GO_INSTALL_DIR..."
rm -rf "$GO_INSTALL_DIR"
mkdir -p "$HOME/.local"
tar -C "$HOME/.local" -xzf "$TARBALL"
rm "$TARBALL"

# Check if PATH is already configured
if ! grep -q 'GO_HOME' ~/.bashrc 2>/dev/null; then
    info "Adding Go to PATH in ~/.bashrc..."
    cat >> ~/.bashrc << 'EOF'

# Go
export GO_HOME="$HOME/.local/go"
export PATH="$PATH:$GO_HOME/bin"
export PATH="$PATH:$HOME/go/bin"
EOF
fi

export PATH="$PATH:$GO_INSTALL_DIR/bin"

info "Go installed: $($GO_INSTALL_DIR/bin/go version)"
info "Run 'source ~/.bashrc' or restart your shell."
