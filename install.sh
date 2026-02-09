#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    error "Unsupported OS: $OSTYPE"
    exit 1
fi

DOTFILES_DIR="$SCRIPT_DIR"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# ============================================
# System packages
# ============================================
install_system_packages() {
    info "Installing system packages..."

    if [[ "$OS" == "linux" ]]; then
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y \
            build-essential \
            gdb \
            unzip \
            curl \
            wget \
            git \
            trash-cli \
            xclip
    elif [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install \
            trash-cli
    fi
}

# ============================================
# mise (tool version manager)
# ============================================
install_mise() {
    info "Installing mise..."

    if command -v "$HOME/.local/bin/mise" &> /dev/null; then
        info "mise is already installed, updating..."
        "$HOME/.local/bin/mise" self-update
    else
        curl https://mise.run | sh
    fi

    info "Installing tools defined in config.toml..."
    "$HOME/.local/bin/mise" install

    info "mise setup complete"
}

# ============================================
# Symlinks
# ============================================
create_symlinks() {
    info "Creating symlinks..."

    mkdir -p "$XDG_CONFIG_HOME"

    # Neovim
    if [[ -d "$XDG_CONFIG_HOME/nvim" ]]; then
        warn "Backing up existing nvim config..."
        mv "$XDG_CONFIG_HOME/nvim" "$XDG_CONFIG_HOME/nvim.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/.config/nvim" "$XDG_CONFIG_HOME/nvim"
    info "Linked: nvim"

    # Fish
    if [[ -d "$DOTFILES_DIR/.config/fish" ]]; then
        mkdir -p "$XDG_CONFIG_HOME/fish"
        if [[ -f "$XDG_CONFIG_HOME/fish/config.fish" ]]; then
            mv "$XDG_CONFIG_HOME/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish.backup"
        fi
        ln -sf "$DOTFILES_DIR/.config/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
        info "Linked: fish"
    fi

    # Bashrc
    if [[ -f "$HOME/.bashrc" ]]; then
        mv "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    info "Linked: bashrc"

    # Tmux
    if [[ -f "$HOME/.tmux.conf" ]]; then
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    info "Linked: tmux.conf"

    # mise
    mkdir -p "$XDG_CONFIG_HOME/mise"
    ln -sf "$DOTFILES_DIR/.config/mise/config.toml" "$XDG_CONFIG_HOME/mise/config.toml"
    info "Linked: mise/config.toml"
}

# ============================================
# Git configuration
# ============================================
setup_git() {
    info "Setting up Git..."
    git config --global user.name "Takuya Mizokami"
    git config --global user.email "takoyaki65@users.noreply.github.com"
    info "Git configured"
}

# ============================================
# Main
# ============================================
main() {
    echo ""
    echo "======================================"
    echo "  Dotfiles Installation Script"
    echo "======================================"
    echo ""

    PS3="Select components to install (space-separated numbers, or 'a' for all): "
    options=(
        "System packages"
        "mise (dev tools)"
        "Symlinks"
        "Git configuration"
        "All"
        "Quit"
    )

    # Default: install all
    if [[ "$1" == "--all" || "$1" == "-a" ]]; then
        install_system_packages
        create_symlinks
        install_mise
        setup_git
        echo ""
        info "All components installed successfully!"
        info "Please restart your shell or run: source ~/.bashrc"
        exit 0
    fi

    select opt in "${options[@]}"; do
        case $opt in
            "System packages") install_system_packages ;;
            "mise (dev tools)") install_mise ;;
            "Symlinks") create_symlinks ;;
            "Git configuration") setup_git ;;
            "All")
                install_system_packages
                create_symlinks
                install_mise
                setup_git
                ;;
            "Quit") break ;;
            *) error "Invalid option" ;;
        esac
    done

    echo ""
    info "Installation complete!"
    info "Please restart your shell or run: source ~/.bashrc"
}

main "$@"
