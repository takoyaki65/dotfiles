{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terminal (Ghostty is installed via Homebrew on macOS)

    # Essentials
    tmux
    neovim

    # Search & file utilities
    ripgrep
    fd
    fzf
    zoxide
    bat
    eza
    jq
    dust
    yazi
    dust
    zoxide
    trash-cli

    # Git & project management
    git
    ghq
    lazygit
    delta

    # Network & data
    curl
    wget

    # System tools
    htop
    vivid
    direnv

    # Miscellaneous utilities
    fixjson
    shellcheck

    # Package Managers
    nodejs_24
    pnpm
    uv
  ];
}
