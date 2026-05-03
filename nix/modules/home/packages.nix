{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal (Ghostty is installed via Homebrew on macOS)

    # Search & file utils
    ripgrep
    fd
    fzf
    bat
    eza
    yazi
    dust
    zoxide

    # Git & project management
    git
    ghq
    lazygit
    delta

    # Network & data
    curl
    wget
    jq

    # System tools
    tmux
    htop
    vivid
    direnv

    # Shell
    shellcheck

    # Rust
    rustup

    # Python
    uv

    # Node.js
    nodejs_24
    pnpm
  ];
}
